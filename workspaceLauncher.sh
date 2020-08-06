#./genDomainEntities.pl  -domain="sameGeneration" -command="encodings/sameGeneration" -testcasesDir="Instances/SameGeneration" -regex="\." > testcases.dl
#./genDomainEntities.pl -domain="lazyNlpWa" -command="wa" -testcasesDir="lazyConstraints/nlp/instances" -regex="\." > testcases.dl
#./genDomainEntities.pl -domain="packing" -command="../eager_wasp_tests/selected/packing/encoding ../eager_wasp_tests/selected/packing/constraint" -testcasesDir="../eager_wasp_tests/selected/packing/instances" -regex="\." > testcases.dl
./genDomainEntities.pl -domain="partnersUnitPolynomial" -command="../eager_wasp_tests/selected/partnersUnitPolynomial/encoding ../eager_wasp_tests/selected/partnersUnitPolynomial/constraint" -testcasesDir="../eager_wasp_tests/selected/partnersUnitPolynomial/instances" -regex="\." > testcases.dl
./genMakefile.sh specification.dl testcases.dl
make -k -j3
