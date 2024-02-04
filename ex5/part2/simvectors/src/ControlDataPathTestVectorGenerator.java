import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

public class ControlDataPathTestVectorGenerator {

	// ##############################################################
	// #                                                            #
	// #     CONSTANTS                                              #
	// #                                                            #
	// ##############################################################
	private final String STIMULI_FILE_NAME 				= "fsm_stimuli.asc";			// Stimuli file is the same for all control data path runs.
	private final String EXP_RESP_INITIAL_FILE_NAME 	= "fsm_initial_expresp.asc";	// Expected response file for the initial design.
	private final String EXP_RESP_CHANGE1_FILE_NAME 	= "fsm_change1_expresp.asc";	// Expected response file for the first change.
	private final String EXP_RESP_CHANGE2_FILE_NAME 	= "fsm_change2_expresp.asc";	// Expected response file for the second change.

	
	
	// ##############################################################
	// #                                                            #
	// #     MEMBERS                                                #
	// #                                                            #
	// ##############################################################
	
	// General members.
	FileWriter fwStimuli 		= null;
	FileWriter fwExpResp 		= null;
	BufferedWriter bwStimuli	= null;
	BufferedWriter bwExpResp	= null;
	
	// Document specific members.
	private FsmTypes fsmType		= FsmTypes.Initial;
	private String expRespFileName	= EXP_RESP_INITIAL_FILE_NAME;
	private int testVectorCount		= 0;
	private States currentState		= States.one; 		// The reset state is 'one'.
	private boolean addxS			= false;			// Per default 'AddxSO' is not set.
	private boolean constSelxS		= false;			// Per default 'ConstSelxS' is not set.
	private boolean clrCountxS		= false;			// Per default 'ClrCountxS' is not set.
	private boolean clrAccuxS		= false;			// Per default 'ClrAccuxS' is not set.
	private BigInteger countxD		= BigInteger.ZERO;	// Value of 'CountxD' after reset is '0'.
	private BigInteger accuxD		= BigInteger.ZERO;	// Value of 'AccuxD' after reset is '0'.
	private BigInteger inxDI		= BigInteger.ZERO;	// The input value for the design.
	BigInteger addConstxD 			= BigInteger.ZERO;
	
	BigInteger[] inxDIArray 		= new BigInteger[]{
			new BigInteger("00A0", 16),
			new BigInteger("FFFF", 16),
			};
	
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		ControlDataPathTestVectorGenerator gen = new ControlDataPathTestVectorGenerator();
		int fsmTypeId = 0;	// 0...Initial, 1...Change1, 2...Change2
		
		if(args.length > 0 && args[0] != null) {
			try {
				fsmTypeId = Integer.parseInt(args[0]);
				switch (fsmTypeId) {
				case 1: gen.fsmType 	= FsmTypes.Change1;	break;
				case 2: gen.fsmType 	= FsmTypes.Change2;	break;
				default: gen.fsmType	= FsmTypes.Initial;	break;
				}
			} catch (NumberFormatException ex) {
				System.err.println("Error: " + ex.toString());
			}
		}
		System.out.println("\n################################");
		System.out.println("Start of test vector generation.");
		System.out.println("FSM Type = " + gen.fsmType.toString());
		gen.generateTestVectors();
		System.out.println("End of test vector generation.");
		System.out.println("Number of generated test vectors: " + gen.testVectorCount);
		System.out.println("################################");
	}
	
	private void generateTestVectors() {
		
		switch (fsmType) {
		case Initial:	expRespFileName = EXP_RESP_INITIAL_FILE_NAME; 	break;
		case Change1:	expRespFileName = EXP_RESP_CHANGE1_FILE_NAME;	break;
		case Change2:	expRespFileName = EXP_RESP_CHANGE2_FILE_NAME;	break;
		default:
			break;
		}
		try {
			// Create file.
			fwStimuli 	= new FileWriter(STIMULI_FILE_NAME);
			fwExpResp	= new FileWriter(expRespFileName);
			bwStimuli	= new BufferedWriter(fwStimuli);
			bwExpResp	= new BufferedWriter(fwExpResp);
			
			// Generate file headers.
			writeStimuliHeader();
			writeExpRespHeader();
			
			for (BigInteger bigInt : inxDIArray) {
				// Generate reset.
				reset(2);
				
				// Set input value.
				inxDI = bigInt;
				
				// Run the design.
				runFsm(30);
			}
			
			//Close the output stream.
			bwStimuli.close();
			bwExpResp.close();
			
		} catch (Exception ex) {
			System.err.println("Error: " + ex.toString());
 		}
	}
	
	private void reset(int _cycles) {
		for (int i = 0; i < _cycles; i++) {
			currentState = States.one;
			accuxD 	= BigInteger.ZERO;
			countxD	= BigInteger.ZERO;
			writeStimuliLine(BigInteger.ZERO, BigInteger.ZERO, "Reset");
			writeExpRespLine(BigInteger.ZERO, "Reset");
			testVectorCount++;
		}
	}
	
	private void runFsm(int _cycles) {
		switch (fsmType) {
		case Change1:	runFsmChange1(_cycles);	break;
		case Change2:	runFsmChange2(_cycles);	break;
		case Initial: 	
		default:		runFsmInitial(_cycles); break;
		}
	}
	
	private void runFsmInitial(int _cycles) {
		
		for (int i = 0; i < _cycles; i++) {
			testVectorCount++;
			writeStimuliLine(BigInteger.ONE, inxDI, "InxDI=0x" + inxDI.toString(16).toUpperCase());
			writeExpRespLine(accuxD, String.format("OutxDO=0x%s, State=%s",
					padLeft(accuxD.toString(16).toUpperCase(), '0', 4),
					currentState.toString()));
			
			// Default values.
			addxS 		= false;
			constSelxS	= false;
			clrCountxS	= false;
			
			switch (currentState) {

			case one:
				constSelxS 		= true;
				clrCountxS		= true;
				currentState 	= States.two;
				break;

			case two:
				constSelxS = true;
				if(countxD.compareTo(BigInteger.valueOf(4)) > 0 ) {
					currentState = States.three;
				}
				break;
				
			case three:
				addxS = true;
				if(countxD.compareTo(BigInteger.valueOf(9)) > 0 ) {
					currentState = States.four;
				}
				break;

			case four:
				addxS = true;
				currentState = States.one;
				break;
				
			default:
				break;
			}
			
			runDatapath(inxDI);
		}
	}
	
	private void runFsmChange1(int _cycles) {
		
		for (int i = 0; i < _cycles; i++) {
			testVectorCount++;
			writeStimuliLine(BigInteger.ONE, inxDI, "InxDI=0x" + inxDI.toString(16).toUpperCase());
			writeExpRespLine(accuxD, String.format("OutxDO=0x%s, State=%s",
					padLeft(accuxD.toString(16).toUpperCase(), '0', 4),
					currentState.toString()));
			
			// Default values.
			addxS 		= false;
			constSelxS	= false;
			clrCountxS	= false;
			clrAccuxS	= false;
			
			switch (currentState) {

			case one:
				constSelxS 		= true;
				clrCountxS		= true;
				clrAccuxS		= true;
				currentState 	= States.two;
				break;

			case two:
				constSelxS = true;
				if(countxD.compareTo(BigInteger.valueOf(4)) > 0 ) {
					currentState = States.three;
				}
				break;
				
			case three:
				addxS = true;
				if(countxD.compareTo(BigInteger.valueOf(9)) > 0 ) {
					currentState = States.four;
				}
				break;

			case four:
				addxS = true;
				currentState = States.one;
				break;
				
			default:
				break;
			}
			
			runDatapath(inxDI);
		}
	}
	
	private void runFsmChange2(int _cycles) {
		
		for (int i = 0; i < _cycles; i++) {
			testVectorCount++;
			writeStimuliLine(BigInteger.ONE, inxDI, "InxDI=0x" + inxDI.toString(16).toUpperCase());
			writeExpRespLine(accuxD, String.format("OutxDO=0x%s, State=%s",
					padLeft(accuxD.toString(16).toUpperCase(), '0', 4),
					currentState.toString()));
			
			// Default values.
			addxS 		= false;
			constSelxS	= false;
			clrCountxS	= false;
			clrAccuxS	= false;
			
			switch (currentState) {

			case one:
				constSelxS 		= true;
				clrCountxS		= true;
				clrAccuxS		= true;
				currentState 	= States.two;
				break;

			case two:
				constSelxS = true;
				if(countxD.compareTo(BigInteger.valueOf(4)) > 0 ) {
					currentState = States.three;
				}
				break;
				
			case three:
				addxS = true;
				if(countxD.compareTo(BigInteger.valueOf(9)) > 0 ) {
					currentState = States.four;
				}
				break;

			case four:
				addxS 		= true;
				if(addConstxD.compareTo(BigInteger.ZERO) == 0) {
					currentState = States.two;
				} else {
					currentState = States.one;
				}
				break;
				
			default:
				break;
			}
			
			runDatapath(inxDI);
		}
	}
		
	private void runDatapath(BigInteger _inxDI) {
		addConstxD 	= (constSelxS ? _inxDI.add(new BigInteger("FFFF", 16)) : _inxDI.add(BigInteger.ONE));
		addConstxD	= addConstxD.and(new BigInteger("FFFF", 16));
	
		accuxD		= (clrAccuxS ? BigInteger.ZERO : (addxS ? addConstxD.add(accuxD) : addConstxD.subtract(accuxD)));
		accuxD		= accuxD.and(new BigInteger("FFFF", 16));
		
		countxD 	= (clrCountxS ? BigInteger.ZERO : (countxD.add(BigInteger.ONE).mod(BigInteger.valueOf(16))));
	}
	
	private void writeStimuliHeader() {
		try {
			bwStimuli.write("% Content:     Stimuli for the control/data path test bench.\n");
			bwStimuli.write("% Author:      mbgh\n");
			bwStimuli.write("% Created:     " + new Date().toString() + "\n");
			bwStimuli.write("%\n");
			bwStimuli.write("% Modification History:\n");
			bwStimuli.write("% - 2012.03.26: Initial version.\n");
			bwStimuli.write("%\n");
			bwStimuli.write("%RstxRBI\n");
			bwStimuli.write("% InxDI\n");
			bwStimuli.write("% |                Comments\n");
			bwStimuli.write("% |                |\n");
		} catch (IOException ex) {
			System.err.println("Error: " + ex.getMessage());
		}
	}
	private void writeExpRespHeader() {
		try {
			bwExpResp.write("% Content:     Expected responses for the control/data path test bench.\n");
			bwExpResp.write("% Author:      mbgh\n");
			bwExpResp.write("% Type:        " + fsmType.toString() + "\n");
			bwExpResp.write("% Created:     " + new Date().toString() + "\n");
			bwExpResp.write("%\n");
			bwExpResp.write("% Modification History:\n");
			bwExpResp.write("% - 2012.03.26: Initial version.\n");
			bwExpResp.write("%\n");
			bwExpResp.write("%OutxDO\n");
			bwExpResp.write("%                   Comments\n");
			bwExpResp.write("%                   |\n");
		} catch (IOException ex) {
			System.err.println("Error: " + ex.getMessage());
		}
	}
	private void writeStimuliLine(BigInteger _reset, BigInteger _inxDI) {
		writeStimuliLine(_reset, _inxDI, "");
	}
	private void writeStimuliLine(BigInteger _reset, BigInteger _inxDI,
			String _comment) {
		writeStimuliLine(_reset.toString(2), _inxDI.toString(2), _comment);
	}
	private void writeStimuliLine(String _reset, String _inxDI) {
		writeStimuliLine(_reset, _inxDI, "");
	}
	private void writeStimuliLine(String _reset, String _inxDI,
			String _comment) {
		try {
			bwStimuli.write(String.format("%s %s -- %s\n",
					padLeft(_reset, '0', 1),
					padLeft(_inxDI, '0', 16),
					_comment));
		} catch (IOException ex) {
			System.err.println("Error: " + ex.getMessage());
		}
	}
	
	private void writeExpRespLine(BigInteger _outxD) {
		writeExpRespLine(_outxD.toString(2), "");
	}
	private void writeExpRespLine(BigInteger _outxD, String _comment) {
		writeExpRespLine(_outxD.toString(2), _comment);
	}
	private void writeExpRespLine(String _outxD, String _comment) {
		try {
			bwExpResp.write(String.format("%s -- %s\n",
					padLeft(_outxD, '0', 16),
					_comment));
		} catch (IOException ex) {
			System.err.println("Error: " + ex.getMessage());
		}
	}
	
	private String padLeft(String _input, char _padChar, int _width) {

		// Create padding string.
		char[] fillCharArray = new char[_width];
		Arrays.fill(fillCharArray, _padChar);
		String padString = new String(fillCharArray);
		
		return String.format("%s%s", padString, _input).substring(_input.length());
	}
	
	private enum States {
		one,
		two,
		three,
		four
	}
	private enum FsmTypes {
		Initial,
		Change1,
		Change2
	}
}
