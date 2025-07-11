.PHONY=all

all:
  apt install -y build-essential cmake libgmp-dev libsodium-dev nasm curl m4 git wget unzip nlohmann-json3-dev
  mkdir spend && cd spend && wget https://circuitscan-artifacts.s3.us-west-2.amazonaws.com/build/spend-nice-olive-raven/pkg.zip
  cd spend && unzip pkg.zip && cd build/verify_circuit/verify_circuit_cpp && make
  mkdir proof_of_burn && cd proof_of_burn && wget https://circuitscan-artifacts.s3.us-west-2.amazonaws.com/build/proofofburn-unconscious-sapphire-gorilla/pkg.zip
  cd proof_of_burn && unzip pkg.zip && cd build/verify_circuit/verify_circuit_cpp && make
  git clone --recurse-submodules https://github.com/iden3/rapidsnark
  cd rapidsnark && ./build_gmp.sh host && make
