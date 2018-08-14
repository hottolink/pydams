from libcpp.string cimport string
from libcpp.vector cimport vector

cdef extern from "dams.h" namespace "damswrapper":
	cdef cppclass AddressElement:
		AddressElement()
		AddressElement(int level, float x, float y)
		string get_name()
		int get_level()
		float get_x()
		float get_y()

	ctypedef vector[AddressElement] Candidate

	void init()
	void init(string& damsFileName)
	void init_safe()
	void init_safe(string& damsFileName)
	const char* default_dic_path()
	void retrieve(int& score, string& tail, vector[Candidate]& candidates, string query) except +
