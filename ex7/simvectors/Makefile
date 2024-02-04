all: stim.ppm

%.ppm: %.png
	convert $< $@

stim:
	python3 img2ascii.py stim.png
	python3 img2ascii.py exp_resp.png

resp:
	python3 ascii2img.py act_resp.txt

deps:
	pip3 install --user Pillow pil-compat

.PHONY: clean
clean:
	rm -r *.txt *.out *.ppm act_resp.png  || true
