import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigInteger;

public class TrafficLightTestVectorGenerator {

	// ##############################################################
	// #                                                            #
	// #     CONSTANTS                                              #
	// #                                                            #
	// ##############################################################
	private final String STIMULI_FILE_NAME 				= "traffic_light_stimuli.asc";	// Stimuli file is the same for all traffic light runs.
	private final String EXP_RESP_INITIAL_FILE_NAME 	= "initial_expresp.asc";		// Stimuli file for the good initial design.
	private final String EXP_RESP_RED2GREEN_FILE_NAME 	= "red2green_expresp.asc";		// Stimuli file for the good design which changes directly from state 'Red' to 'Green'.
	private final String EXP_RESP_FLASH_ALL_FILE_NAME 	= "flash_all_expresp.asc";		// Stimuli file for the good design which flashes all lights when the button is pressed.
	
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
	private States currentState		= States.Red; 		// Traffic light state after reset.
	private BigInteger timer		= BigInteger.ZERO;	// Timer is not set by default.
	private BigInteger button		= BigInteger.ZERO;	// Button is not set by default.
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		TrafficLightTestVectorGenerator gen = new TrafficLightTestVectorGenerator();
		int fsmTypeId = 0;	// 0...Initial, 1...Red2Green, 2...FlashAll
		
		if(args.length > 0 && args[0] != null) {
			try {
				fsmTypeId = Integer.parseInt(args[0]);
				switch (fsmTypeId) {
				case 1: gen.fsmType 	= FsmTypes.Red2Green;	break;
				case 2: gen.fsmType 	= FsmTypes.FlashAll;	break;
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
		case Red2Green:	expRespFileName = EXP_RESP_RED2GREEN_FILE_NAME;	break;
		case FlashAll:	expRespFileName = EXP_RESP_FLASH_ALL_FILE_NAME;	break;
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
			
			// Generate reset.
			reset(2);
			
			// Run standard traffic light period.
			runTrafficLight(5, 3);
			
			// Press button activity.
			pressButton(1);
			
			// Perform some further button events and standard traffic light periods.
			runTrafficLight(5, 3);
			pressButton(2);
			runTrafficLight(5, 3);
			pressButton(10);
			runTrafficLight(5, 3);
			
			//Close the output stream.
			bwStimuli.close();
			bwExpResp.close();
			
		} catch (Exception ex) {
			System.err.println("Error: " + ex.toString());
 		}
	}
	
	private void reset(int _cycles) {
		for (int i = 0; i < _cycles; i++) {
			writeStimuliLine(BigInteger.ZERO, BigInteger.ZERO, BigInteger.ZERO, "Reset");
			writeExpRespLine("100", "Reset");
			testVectorCount++;
		}
	}
	
	private void runFsm(int _cycles) {
		switch (fsmType) {
		case Initial: 	runFsmInitial(_cycles); 	break;
		case Red2Green:	runFsmRed2Green(_cycles);	break;
		case FlashAll:	runFsmFlashAll(_cycles);	break;
		default:
			break;
		}
	}
	private void runTrafficLight(int _redStateCycles, int _greenStateCycles) {
		runFsm(_redStateCycles);	// Run FSM for certain cycles in state 'Red' with.
		timer = BigInteger.ONE;		// Set timer.
		runFsm(1);					// Change from state 'Red' to 'toGreen'.
		timer = BigInteger.ZERO;	// Reset timer.
		runFsm(1);					// Change from state 'toGreen' to 'Green'.
		runFsm(_greenStateCycles);	// Run FSM for certain cycles in state 'Green' with.
		timer = BigInteger.ONE;		// Set timer.
		runFsm(1);					// Change from state 'Green' to 'toRed'.
		timer = BigInteger.ZERO;	// Reset timer.
		runFsm(1);					// Change from state 'toRed' to 'Red'.
		runFsm(_redStateCycles);	// Run FSM for certain cycles in state 'Red' with.
	}
	
	private void pressButton(int _buttonPressedCycles) {
		button = BigInteger.ONE;
		for (int i = 0; i < _buttonPressedCycles; i++) {
			runFsm(1);
		}
		button = BigInteger.ZERO;
	}
	
	private void runFsmInitial(int _cycles) {
		for (int i = 0; i < _cycles; i++) {
			writeStimuliLine(BigInteger.ONE, timer, button);
			testVectorCount++;
			switch (currentState) {

			case Red:
				writeExpRespLine("100", "Current State: Red");
				
				if (button.equals(BigInteger.ONE)) {
					currentState = States.Dark;
				} else if (timer.equals(BigInteger.ONE)) {
					currentState = States.toGreen;
				}
				break;

			case toGreen:
				writeExpRespLine("110", "Current State: toGreen");
				currentState = States.Green;
				break;
				
			case Green:
				writeExpRespLine("001", "Current State: Green");
				
				if (timer.equals(BigInteger.ONE)) {
					currentState = States.toRed;
				}
				break;

			case toRed:
				writeExpRespLine("010", "Current State: toRed");
				currentState = States.Red;
				break;
				
			case Dark:
				writeExpRespLine("000", "Current State: Dark");
				if (button.equals(BigInteger.ONE)) {
					currentState = States.Blink;
				} else {
					currentState = States.Red;
				}
				break;
				
			case Blink:
				writeExpRespLine("010", "Current State: Blink");
				currentState = States.Dark;
				break;
				
			default:
				break;
			}
		}
	}
	private void runFsmRed2Green(int _cycles) {
		for (int i = 0; i < _cycles; i++) {
			writeStimuliLine(BigInteger.ONE, timer, button);
			testVectorCount++;
			switch (currentState) {

			case Red:
				writeExpRespLine("100", "Current State: Red");
				
				if (button.equals(BigInteger.ONE)) {
					currentState = States.Dark;
				} else if (timer.equals(BigInteger.ONE)) {
					currentState = States.Green;
				}
				break;

			case toGreen:
				writeExpRespLine("110", "Current State: toGreen");
				currentState = States.Green;
				break;
				
			case Green:
				writeExpRespLine("001", "Current State: Green");
				
				if (timer.equals(BigInteger.ONE)) {
					currentState = States.toRed;
				}
				break;

			case toRed:
				writeExpRespLine("010", "Current State: toRed");
				currentState = States.Red;
				break;
				
			case Dark:
				writeExpRespLine("000", "Current State: Dark");
				if (button.equals(BigInteger.ONE)) {
					currentState = States.Blink;
				} else {
					currentState = States.Red;
				}
				break;
				
			case Blink:
				writeExpRespLine("010", "Current State: Blink");
				currentState = States.Dark;
				break;
				
			default:
				break;
			}
		}
	}
	private void runFsmFlashAll(int _cycles) {
		for (int i = 0; i < _cycles; i++) {
			writeStimuliLine(BigInteger.ONE, timer, button);
			testVectorCount++;
			switch (currentState) {

			case Red:
				writeExpRespLine("100", "Current State: Red");
				
				if (button.equals(BigInteger.ONE)) {
					currentState = States.Dark;
				} else if (timer.equals(BigInteger.ONE)) {
					currentState = States.Green;
				}
				break;

			case toGreen:
				writeExpRespLine("110", "Current State: toGreen");
				currentState = States.Green;
				break;
				
			case Green:
				writeExpRespLine("001", "Current State: Green");
				
				if (timer.equals(BigInteger.ONE)) {
					currentState = States.toRed;
				}
				break;

			case toRed:
				writeExpRespLine("010", "Current State: toRed");
				currentState = States.Red;
				break;
				
			case Dark:
				writeExpRespLine("000", "Current State: Dark");
				if (button.equals(BigInteger.ONE)) {
					currentState = States.Blink;
				} else {
					currentState = States.Red;
				}
				break;
				
			case Blink:
				writeExpRespLine("111", "Current State: Blink");
				currentState = States.Dark;
				break;
				
			default:
				break;
			}
		}
	}
	
	private void writeStimuliHeader() {
		try {
			bwStimuli.write("% Content:     Stimuli for the traffic light test bench.\n");
			bwStimuli.write("% Author:      mbgh\n");
			bwStimuli.write("%\n");
			bwStimuli.write("% Modification History:\n");
			bwStimuli.write("% - 2012.03.20: Initial version.\n");
			bwStimuli.write("%\n");
			bwStimuli.write("%RstxRBI\n");
			bwStimuli.write("% TimerxSI\n");
			bwStimuli.write("% | ButtonxSI\n");
			bwStimuli.write("% | |    Comments\n");
			bwStimuli.write("% | |    |\n");
		} catch (IOException ex) {
			System.err.println("Error: " + ex.getMessage());
		}
	}
	private void writeExpRespHeader() {
		try {
			bwExpResp.write("% Content:     Expected responses for the traffic light test bench.\n");
			bwExpResp.write("% Author:      mbgh\n");
			bwExpResp.write("%\n");
			bwExpResp.write("% Modification History:\n");
			bwExpResp.write("% - 2012.03.20: Initial version.\n");
			bwExpResp.write("%\n");
			bwExpResp.write("%LightsxDO\n");
			bwExpResp.write("%      Comments\n");
			bwExpResp.write("%      |\n");
		} catch (IOException ex) {
			System.err.println("Error: " + ex.getMessage());
		}
	}
	private void writeStimuliLine(BigInteger _reset, BigInteger _timer,
			BigInteger _button) {
		writeStimuliLine(_reset, _timer, _button, "");
	}
	private void writeStimuliLine(BigInteger _reset, BigInteger _timer,
			BigInteger _button, String _comment) {
		writeStimuliLine(_reset.toString(), _timer.toString(), _button.toString(),
				_comment);
	}
	private void writeStimuliLine(String _reset, String _timer, String _button) {
		writeStimuliLine(_reset, _timer, _button, "");
	}
	private void writeStimuliLine(String _reset, String _timer,
			String _button, String _comment) {
		try {
			bwStimuli.write(String.format("%s %s %s -- %s\n", _reset, _timer, _button, _comment));
		} catch (IOException ex) {
			System.err.println("Error: " + ex.getMessage());
		}
	}
	
	private void writeExpRespLine(BigInteger _lights) {
		writeExpRespLine(_lights.toString(), "");
	}
	private void writeExpRespLine(BigInteger _lights, String _comment) {
		writeExpRespLine(_lights.toString(), _comment);
	}
	private void writeExpRespLine(String _lights, String _comment) {
		try {
			bwExpResp.write(String.format("%s -- %s\n", _lights, _comment));
		} catch (IOException ex) {
			System.err.println("Error: " + ex.getMessage());
		}
	}
	
	private enum States {
		Dark,
		Red,
		toGreen,
		Blink,
		toRed,
		Green
	}
	private enum FsmTypes {
		Initial,
		Red2Green,
		FlashAll
	}
}
