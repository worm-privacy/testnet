.PHONY=all

all:
	mkdir -p out

	echo "Downloading proof-of-burn-circuit build files..."
	mkdir -p proof_of_burn && cd proof_of_burn && wget -q https://circuitscan-artifacts.s3.us-west-2.amazonaws.com/build/proofofburn-unconscious-sapphire-gorilla/pkg.zip
	echo "Building proof-of-burn-circuit witness generator..."
	cd proof_of_burn && unzip pkg.zip "build/*" -d build && cd build/verify_circuit/verify_circuit_cpp && make
	cp proof_of_burn/build/verify_circuit/verify_circuit_cpp/verify_circuit out/proof_of_burn
	cp proof_of_burn/build/verify_circuit/verify_circuit_cpp/verify_circuit.dat out/proof_of_burn.dat
	# mv proof_of_burn/build/verify_circuit/groth16_vkey.json out/proof_of_burn.zkey

	echo "Building WORM miner..."
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	git clone https://github.com/worm-privacy/miner
	. ~/.bashrc
	cd miner && cargo build --release
	cp miner/target/release/worm-miner out/worm-miner

	echo "Installing requirements..."
	sudo apt install -y build-essential cmake libgmp-dev libsodium-dev nasm curl m4 git wget unzip nlohmann-json3-dev

	echo "Downloading spend-circuit build files..."
	mkdir -p spend && cd spend && wget -q https://circuitscan-artifacts.s3.us-west-2.amazonaws.com/build/spend-nice-olive-raven/pkg.zip
	echo "Building spend-circuit witness generator..."
	cd spend && unzip pkg.zip && cd build/verify_circuit/verify_circuit_cpp && make
	cp spend/build/verify_circuit/verify_circuit_cpp/verify_circuit out/spend
	cp spend/build/verify_circuit/verify_circuit_cpp/verify_circuit.dat out/spend.dat
	mv spend/build/verify_circuit/groth16_vkey.json out/spend.zkey

	echo "Building rapidsnark..."
	git clone --recurse-submodules https://github.com/iden3/rapidsnark
	cd rapidsnark && ./build_gmp.sh host && make
	cp rapidsnark/package/bin/prover out/rapidsnark
