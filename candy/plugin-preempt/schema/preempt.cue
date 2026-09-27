// plugin-preempt's OWN self-contained CUE schema — the SINGLE SOURCE for this plugin's
// declaration surface, served over the Describe channel (there is no schema-less
// plugin). SELF-CONTAINED: it references no base def, so it compiles STANDALONE (the
// property the SDK's serve-side compile and `cue exp gengotypes` both need).
//
// The plugin serves `verb:arbiter` (the exclusive/shared resource arbiter, reached
// peer-to-peer via InvokeProvider) and `command:preempt` (the operator CLI). Neither
// declares a structured plugin_input, so this schema DOCUMENTS the capability pair.
#PreemptPlugin: {
	// What the plugin does, in one line (the public-docs surface).
	contract: string & !=""

	// The capabilities the plugin serves.
	verbs:    ["arbiter"]
	commands: ["preempt"]
}
