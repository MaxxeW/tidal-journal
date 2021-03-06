
(
SynthDef(\karplus01, {
	|
	freq=440, amp=1, gate=1, pan=0,out=0,
	attack = 0.002,sustain=1,decay=0.2,release=0.5,
	harmonic=1.0, brightness=1,overdrive=1,spread=0.01,muted=0.07
	|
	var smoothFreq, vibFreq, oscL, oscR, oscC, env, noise, detune,strike,mixL,mixR;
	var maxDelay = 30.reciprocal;

	smoothFreq = Lag.kr(freq);
	vibFreq = Vibrato.kr(smoothFreq,0.5,0.01);
	detune = spread*1.midicps/4;



	strike = Impulse.kr(0);
	noise = PinkNoise.ar(1);
	oscL = Pluck.ar(noise,strike,maxDelay,(harmonic*vibFreq+detune).reciprocal,50,coef:(0-muted.tanh));
	noise = PinkNoise.ar(1);
	oscR = Pluck.ar(noise,strike,maxDelay,(harmonic*vibFreq-detune).reciprocal,50,coef:muted.tanh);
	noise = PinkNoise.ar(1);
	oscC = Pluck.ar(noise,strike,maxDelay,(vibFreq/2).reciprocal,10,coef:muted.tanh);

	env = EnvGen.ar(Env.adsr(attack,decay,1,release, 1, -4), gate, timeScale:sustain, doneAction:2);

	overdrive = overdrive + 1;

	mixL = BLowPass.ar((oscC+oscR),freq*3*brightness);
	mixR = BLowPass.ar((oscC+ oscL),freq*3*brightness);

	mixL = (overdrive*(oscC+ oscL)/2).tanh;
	mixR = (overdrive*(oscC+ oscL)/2).tanh;

	OffsetOut.ar(out, DirtPan.ar(mixL/10, ~dirt.numChannels, pan-spread, env));
	OffsetOut.ar(out, DirtPan.ar(mixR/10, ~dirt.numChannels, pan+spread, env));
}).add
)

// Synth(\karplus01);

