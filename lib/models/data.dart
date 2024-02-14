// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Welcome> welcomeFromJson(String str) =>
    List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
  String txid;
  int version;
  int locktime;
  List<Vin> vin;
  List<Vout> vout;
  int size;
  int weight;
  int sigops;
  int fee;
  Status status;

  Welcome({
    required this.txid,
    required this.version,
    required this.locktime,
    required this.vin,
    required this.vout,
    required this.size,
    required this.weight,
    required this.sigops,
    required this.fee,
    required this.status,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        txid: json["txid"],
        version: json["version"],
        locktime: json["locktime"],
        vin: List<Vin>.from(json["vin"].map((x) => Vin.fromJson(x))),
        vout: List<Vout>.from(json["vout"].map((x) => Vout.fromJson(x))),
        size: json["size"],
        weight: json["weight"],
        sigops: json["sigops"],
        fee: json["fee"],
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "txid": txid,
        "version": version,
        "locktime": locktime,
        "vin": List<dynamic>.from(vin.map((x) => x.toJson())),
        //"vout": List<dynamic>.from(vout.map((x) => x.toJson())),
        "size": size,
        "weight": weight,
        "sigops": sigops,
        "fee": fee,
        "status": status.toJson(),
      };
}

class Status {
  bool confirmed;
  int blockHeight;
  String blockHash;
  int blockTime;

  Status({
    required this.confirmed,
    required this.blockHeight,
    required this.blockHash,
    required this.blockTime,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        confirmed: json["confirmed"] ?? false,
        blockHeight: json["block_height"] ?? 0,
        blockHash: json["block_hash"] ?? '',
        blockTime: json["block_time"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "confirmed": confirmed,
        "block_height": blockHeight,
        "block_hash": blockHash,
        "block_time": blockTime,
      };
}

class Vin {
  String txid;
  int vout;
  Vout prevout;
  String scriptsig;
  String scriptsigAsm;
  List<String> witness;
  bool isCoinbase;
  int sequence;
  String? innerWitnessscriptAsm;

  Vin({
    required this.txid,
    required this.vout,
    required this.prevout,
    required this.scriptsig,
    required this.scriptsigAsm,
    required this.witness,
    required this.isCoinbase,
    required this.sequence,
    this.innerWitnessscriptAsm,
  });

  factory Vin.fromJson(Map<String, dynamic> json) => Vin(
        txid: json["txid"],
        vout: json["vout"],
        prevout: Vout.fromJson(json["prevout"]),
        scriptsig: json["scriptsig"],
        scriptsigAsm: json["scriptsig_asm"],
        witness: List<String>.from(json["witness"].map((x) => x)),
        isCoinbase: json["is_coinbase"],
        sequence: json["sequence"],
        innerWitnessscriptAsm: json["inner_witnessscript_asm"],
      );

  Map<String, dynamic> toJson() => {
        "txid": txid,
        "vout": vout,
        "prevout": prevout.toJson(),
        "scriptsig": scriptsig,
        "scriptsig_asm": scriptsigAsm,
        "witness": List<dynamic>.from(witness.map((x) => x)),
        "is_coinbase": isCoinbase,
        "sequence": sequence,
        "inner_witnessscript_asm": innerWitnessscriptAsm,
      };
}

class Vout {
  String scriptpubkey;
  String scriptpubkeyAsm;
  //ScriptpubkeyType scriptpubkeyType;
  String scriptpubkeyAddress;
  int value;

  Vout({
    required this.scriptpubkey,
    required this.scriptpubkeyAsm,
    //required this.scriptpubkeyType,
    required this.scriptpubkeyAddress,
    required this.value,
  });

  factory Vout.fromJson(Map<String, dynamic> json) => Vout(
        scriptpubkey: json["scriptpubkey"],
        scriptpubkeyAsm: json["scriptpubkey_asm"],
        //scriptpubkeyType: scriptpubkeyTypeValues.map[json["scriptpubkey_type"]]!,
        scriptpubkeyAddress: json["scriptpubkey_address"] ?? "",
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "scriptpubkey": scriptpubkey,
        "scriptpubkey_asm": scriptpubkeyAsm,
        //"scriptpubkey_type": scriptpubkeyTypeValues.reverse[scriptpubkeyType],
        "scriptpubkey_address": scriptpubkeyAddress,
        "value": value,
      };
}

enum ScriptpubkeyType { V0_P2_WPKH, V1_P2_TR }

final scriptpubkeyTypeValues = EnumValues({
  "v0_p2wpkh": ScriptpubkeyType.V0_P2_WPKH,
  "v1_p2tr": ScriptpubkeyType.V1_P2_TR
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
