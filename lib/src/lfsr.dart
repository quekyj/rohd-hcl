// ignore_for_file: public_member_api_docs

import 'package:rohd/rohd.dart';

class LFSR extends Module {
  Logic get lsfrOut => output('lsfr_output');
  LFSR(Logic clk, Logic reset) {
    clk = addInput('clk', clk);
    reset = addInput('reset', reset);

    final lfsrOut = addOutput('lfsr_output');

    final shiftReg = Logic(name: 'shift_register', width: 3);

    Sequential(clk, [
      If(reset, then: [
        shiftReg < Const(0),
      ], orElse: [
        shiftReg < [shiftReg[2] ^ shiftReg[1], shiftReg.slice(1, 0)].swizzle()
      ])
    ]);

    shiftReg <= lfsrOut;
  }
}

void main(List<String> args) async {
  final clk = SimpleClockGenerator(10).clk;
  final reset = Logic(name: 'reset');

  final lsfr = LFSR(clk, reset);
}
