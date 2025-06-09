build-simulator:
	flutter build ios --simulator
build-ios:
	flutter build ipa --release --obfuscate --split-debug-info -h
build-android:
	flutter build appbundle --release