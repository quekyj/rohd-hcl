// ignore_for_file: public_member_api_docs

import 'package:rohd/rohd.dart';

class LFSR extends Module {
  Logic get lsfrOut => output('lsfr_output');
  LFSR(Logic clk, Logic reset, {int bitsNum = 16}) {
    clk = addInput('clk', clk);
    reset = addInput('reset', reset);

    final lfsrOut = addOutput('lfsr_output', width: bitsNum);
    final shiftReg = Logic(name: 'shift_register', width: bitsNum);

    Sequential(clk, [
      If(reset, then: [
        shiftReg < 1,
      ], orElse: [
        shiftReg <
            [
              shiftReg.slice(bitsNum - 2, 0),
              shiftReg[bitsNum - 1] ^ shiftReg[bitsNum - 2],
            ].swizzle(),
      ])
    ]);

    lfsrOut <= shiftReg;
  }
}

void main() async {
  final clk = SimpleClockGenerator(10).clk;
  final reset = Logic(name: 'reset');

  final lsfr = LFSR(clk, reset, bitsNum: 3);

  await lsfr.build();

  reset.inject(1);

  WaveDumper(lsfr, outputPath: 'lfsr.vcd');

  Simulator.registerAction(25, () => reset.put(0));
  Simulator.setMaxSimTime(100);
  await Simulator.run();
}
