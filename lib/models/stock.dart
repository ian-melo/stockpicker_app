import 'package:flutter/material.dart';

class Stock {
  String code;
  String name;
  ImageProvider logo;
  int quantity;
  double value;
  double liquidity;
  double ebitMargin;
  double evEbit;
  double roic;
  double roe;
  double pVp;
  double pL;
  double divYield;

  Stock({
    required this.code,
    required this.name,
    required this.logo,
    required this.quantity,
    required this.value,
    required this.liquidity,
    required this.ebitMargin,
    required this.evEbit,
    required this.roic,
    required this.roe,
    required this.pVp,
    required this.pL,
    required this.divYield,
  });

  @override
  String toString() =>
      "code=$code, name=$name, logo=$logo, quantity=$quantity, value=$value,"
      " liquidity=$liquidity, ebitMargin=$ebitMargin, evEbit=$evEbit,"
      " roic=$roic, roe=$roe, pVp=$pVp, pL=$pL, divYield=$divYield";
}
