import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_api_service.dart';
import '../services/user_session.dart';

const Color addressBlue = Color(0xFF1261A0);
const Color addressOrange = Color(0xFFFF7A00);
const Color addressNavy = Color(0xFF0B1F3A);

class AddressData {
  final String id, label, city, line1, line2, landmark, postalCode;
  final bool isDefault;
  const AddressData({required this.id, required this.label, required this.city, required this.line1, required this.line2, required this.landmark, required this.postalCode, this.isDefault = false});
  factory AddressData.fromJson(Map value) {
    final cityValue = value['city_id'];
    return AddressData(
      id: (value['_id'] ?? '').toString(), label: (value['label'] ?? 'OTHER').toString(),
      city: cityValue is Map ? (cityValue['city_name'] ?? '').toString() : (value['city'] ?? '').toString(),
      line1: (value['address_line1'] ?? '').toString(), line2: (value['address_line2'] ?? '').toString(),
      landmark: (value['landmark'] ?? '').toString(), postalCode: (value['postal_code'] ?? '').toString(), isDefault: value['is_default'] == true,
    );
  }
  Map<String, dynamic> toJson() => {'_id':id,'label':label,'address_line1':line1,'address_line2':line2,'landmark':landmark,'postal_code':postalCode,'is_default':isDefault,'city':city};
  String get display => [line2, line1, landmark, city, postalCode].where((e) => e.trim().isNotEmpty).join(', ');
}

class SavedAddressesScreen extends StatefulWidget {
  final List<dynamic> addresses;
  const SavedAddressesScreen({super.key, required this.addresses});
  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  static const String _base = 'http://192.168.1.4:4000/api/v1/customer/addresses';
  late List<AddressData> _items;
  bool _busy = false;
  @override
  void initState() { super.initState(); _items = widget.addresses.whereType<Map>().map((e) => AddressData.fromJson(e)).toList(); }

  Future<Map<String,String>> _headers() async {
    final token = await AuthApiService.getAccessToken();
    if (token == null || token.isEmpty) throw Exception('Login session missing. Please login again.');
    return {'Accept':'application/json','Content-Type':'application/json','accessToken':token,'Authorization':'Bearer $token','x-access-token':token};
  }
  Future<Map<String,dynamic>> _request(Future<http.Response> Function(Map<String,String>) call) async {
    final response = await call(await _headers()).timeout(const Duration(seconds: 30));
    dynamic body; try { body = jsonDecode(response.body); } catch (_) { throw Exception('Invalid server response'); }
    if (body is! Map || response.statusCode < 200 || response.statusCode >= 300 || !(body['success'] == true || body['status'] == true)) throw Exception(body is Map ? (body['message'] ?? 'Request failed').toString() : 'Request failed');
    return Map<String,dynamic>.from(body);
  }
  Future<void> _cache() async => UserSession.updateUser({'_cached_addresses': _items.map((e) => e.toJson()).toList()});
  Future<void> _addOrEdit([AddressData? old]) async {
    final fields = await Navigator.push<Map<String,String>>(context, MaterialPageRoute(builder: (_) => AddAddressScreen(initialAddress: old)));
    if (fields == null || !mounted) return;
    await _save(old, fields);
  }
  Future<void> _save(AddressData? old, Map<String,String> fields) async {
    setState(() => _busy = true);
    try {
      final body = {'label':fields['label'],'address_line1':fields['address_line1'],'address_line2':fields['address_line2'],'landmark':fields['landmark'],'postal_code':fields['postal_code']};
      final result = await _request((h) => old == null
        ? http.post(Uri.parse(_base), headers:h, body:jsonEncode(body))
        : http.patch(Uri.parse('$_base/${old.id}'), headers:h, body:jsonEncode(body)));
      final data = result['data'];
      final raw = data is Map && data['address'] is Map ? data['address'] : data;
      if (raw is Map && raw['_id'] != null) {
        final saved = AddressData.fromJson(raw);
        setState(() { final i = _items.indexWhere((e) => e.id == saved.id); if (i >= 0) { _items[i] = saved; } else { _items.add(saved); } });
      } else {
        // POST response may return only a message; preserve the form values locally until next login.
        setState(() => _items.add(AddressData(id:'', label:body['label']!, city:fields['city'] ?? '', line1:body['address_line1']!, line2:body['address_line2']!, landmark:body['landmark']!, postalCode:body['postal_code']!)));
      }
      await _cache();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(old == null ? 'Address added successfully.' : 'Address updated successfully.')));
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.toString().replaceFirst('Exception: ','')))); }
    finally { if (mounted) setState(() => _busy = false); }
  }
  Future<void> _delete(AddressData a) async {
    if (a.id.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Address ID missing. Please refresh your profile.'))); return; }
    final yes = await showDialog<bool>(context:context,builder:(c)=>AlertDialog(title:const Text('Delete address?'),content:const Text('Are you sure you want to delete this address?'),actions:[TextButton(onPressed:()=>Navigator.pop(c,false),child:const Text('Cancel')),FilledButton(onPressed:()=>Navigator.pop(c,true),child:const Text('Delete'))]));
    if (yes != true) return;
    setState(()=>_busy=true);
    try { await _request((h)=>http.delete(Uri.parse('$_base/${a.id}'),headers:h)); setState(()=>_items.removeWhere((e)=>e.id==a.id)); await _cache(); }
    catch(e){ if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.toString().replaceFirst('Exception: ','')))); }
    finally { if(mounted) setState(()=>_busy=false); }
  }
  Future<void> _default(AddressData a) async {
    if (a.id.isEmpty) return;
    setState(()=>_busy=true);
    try { final r=await _request((h)=>http.patch(Uri.parse('$_base/${a.id}/default'),headers:h,body:'{}')); final data=r['data']; final raw=data is Map && data['address'] is Map ? data['address'] : null; setState(()=>_items= _items.map((e)=>AddressData(id:e.id,label:e.label,city:e.city,line1:e.line1,line2:e.line2,landmark:e.landmark,postalCode:e.postalCode,isDefault:e.id==a.id)).toList()); if(raw is Map){ final updated=AddressData.fromJson(raw); final i=_items.indexWhere((e)=>e.id==updated.id); if(i>=0)_items[i]=updated; } await _cache(); }
    catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.toString().replaceFirst('Exception: ',''))));}
    finally{if(mounted)setState(()=>_busy=false);}
  }
  @override
  Widget build(BuildContext context)=>Scaffold(backgroundColor:const Color(0xFFF7F9FC),appBar:AppBar(backgroundColor:addressNavy,foregroundColor:Colors.white,title:const Text('Saved Addresses',style:TextStyle(fontWeight:FontWeight.w800))),body:Stack(children:[ListView(padding:const EdgeInsets.all(18),children:[if(_items.isEmpty) Container(padding:const EdgeInsets.all(24),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18)),child:const Text('No saved addresses yet. Add your first address.')),..._items.map((a)=>Container(margin:const EdgeInsets.only(bottom:12),padding:const EdgeInsets.all(15),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[const Icon(Icons.location_on_outlined,color:addressBlue),const SizedBox(width:9),Text(a.label,style:const TextStyle(fontWeight:FontWeight.w800,color:addressNavy)),if(a.isDefault)...[const SizedBox(width:8),const Chip(label:Text('DEFAULT'),backgroundColor:Color(0xFFE7F5EC),visualDensity:VisualDensity.compact)] ,const Spacer(),IconButton(onPressed:_busy?null:()=>_addOrEdit(a),icon:const Icon(Icons.edit_outlined,color:addressBlue)),IconButton(onPressed:_busy?null:()=>_delete(a),icon:const Icon(Icons.delete_outline,color:Colors.red))]),Text(a.display,style:const TextStyle(color:Color(0xFF667085),height:1.4)),if(!a.isDefault)Align(alignment:Alignment.centerRight,child:TextButton(onPressed:_busy?null:()=>_default(a),child:const Text('Set as default')))]))),const SizedBox(height:8),SizedBox(height:52,child:FilledButton.icon(onPressed:_busy?null:()=>_addOrEdit(),style:FilledButton.styleFrom(backgroundColor:addressBlue),icon:const Icon(Icons.add),label:const Text('Add New Address')))]),if(_busy)const Positioned.fill(child:ColoredBox(color:Color(0x33000000),child:Center(child:CircularProgressIndicator()))) ]));
}

class AddAddressScreen extends StatefulWidget {
  final AddressData? initialAddress;
  const AddAddressScreen({super.key,this.initialAddress});
  @override State<AddAddressScreen> createState()=>_AddAddressScreenState();
}
class _AddAddressScreenState extends State<AddAddressScreen>{
  final _form=GlobalKey<FormState>(); late final TextEditingController _city,_line1,_line2,_landmark,_pin; late String _label;
  @override void initState(){super.initState();final a=widget.initialAddress;_city=TextEditingController(text:a?.city??'');_line1=TextEditingController(text:a?.line1??'');_line2=TextEditingController(text:a?.line2??'');_landmark=TextEditingController(text:a?.landmark??'');_pin=TextEditingController(text:a?.postalCode??'');_label=a?.label.toUpperCase()??'HOME';}
  @override void dispose(){for(final c in [_city,_line1,_line2,_landmark,_pin]){c.dispose();}super.dispose();}
  Widget _field(String title,String hint,TextEditingController c,{bool optional=false,TextInputType? keyboard,int? max})=>Padding(padding:const EdgeInsets.only(bottom:15),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.w700,color:addressNavy)),const SizedBox(height:7),TextFormField(controller:c,keyboardType:keyboard,maxLength:max,textCapitalization:TextCapitalization.words,validator:(v)=>!optional&&(v==null||v.trim().isEmpty)?'Please enter $title':null,decoration:InputDecoration(counterText:'',hintText:hint,filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:Color(0xFFD9E0E8))),enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:Color(0xFFD9E0E8)))))]));
  @override Widget build(BuildContext context)=>Scaffold(backgroundColor:const Color(0xFFF7F9FC),appBar:AppBar(backgroundColor:addressNavy,foregroundColor:Colors.white,title:Text(widget.initialAddress==null?'Add Address':'Edit Address')),body:Form(key:_form,child:ListView(padding:const EdgeInsets.all(18),children:[const Text('Address Type',style:TextStyle(fontWeight:FontWeight.w700,color:addressNavy)),const SizedBox(height:10),Row(children:['HOME','OFFICE','OTHER'].map((v)=>Expanded(child:Padding(padding:const EdgeInsets.only(right:7),child:ChoiceChip(label:Text(v),selected:_label==v,selectedColor:const Color(0xFFD6E5F2),onSelected:(_)=>setState(()=>_label=v))))).toList()),const SizedBox(height:15),_field('City','Enter city name',_city),_field('Full Address / Area','Area, street, locality',_line1),_field('House / Flat / Building No.','Building or house number',_line2),_field('Area / Landmark (optional)','Near main market, park etc.',_landmark,optional:true),_field('Postal Code','6-digit PIN code',_pin,keyboard:TextInputType.number,max:6),const SizedBox(height:10),SizedBox(height:52,child:FilledButton(onPressed:()=>_submit(),style:FilledButton.styleFrom(backgroundColor:addressBlue),child:Text(widget.initialAddress==null?'Save Address':'Update Address',style:const TextStyle(fontWeight:FontWeight.w700))))])));
  void _submit(){if(!_form.currentState!.validate())return;if(_pin.text.trim().length!=6){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Enter a valid 6-digit PIN code')));return;}Navigator.pop(context,{'label':_label,'city':_city.text.trim(),'address_line1':_line1.text.trim(),'address_line2':_line2.text.trim(),'landmark':_landmark.text.trim(),'postal_code':_pin.text.trim()});}
}
