from __future__ import unicode_literals

cimport DAMS
import copy

cpdef init_dams(damsFileName=None):
	if damsFileName is None:
		# init()
		init_safe()
	else:
		init(damsFileName)
		init_safe(damsFileName)
	return True

cpdef const char* default_dict_path():
	return default_dic_path()

def _get_address_level(lst_dict_addr):
	return lst_dict_addr[-1]["level"]

def _concat_address(lst_dict_addr, separator=""):
	dict_addr_tail = lst_dict_addr[-1]
	ret = copy.copy(dict_addr_tail)
	ret["name"] = separator.join(dict_addr["name"] for dict_addr in lst_dict_addr)
	return ret

cpdef geocode(address, sort_by_address_level=True):
	"""
	execute geocoding request for specified address.
	:param address: address to be geocoded. type should be unicode, not string
	:param sort_by_address_level: sort candidates by the depth of successfully analyzed address level in descending order
	:return: geocoded object, dictionary that contains score, tail and candidates.
	format conforms to the original DAMS specification: http://newspat.csis.u-tokyo.ac.jp/geocode/modules/dams/index.php?content_id=4
	"""

	cdef string query = address.encode("utf-8")

	cdef int score = 0
	cdef string tail
	cdef vector[Candidate] candidates

	try:
		retrieve(score, tail, candidates, query)
	except:
		ret = {
			"score":0,
			"tail":"",
			"candidates":[]
		}
		return ret

	ret = {
		"score":score,
		"tail":tail.decode("utf-8"),
		"candidates":[]
	}

	cdef DAMS.Candidate cand
	cdef DAMS.AddressElement addr
	for cand in candidates:
		lst_addr = []
		for addr in cand:
			dict_addr = {
				"level":addr.get_level(),
				"x":addr.get_x(),
				"y":addr.get_y(),
				"name":addr.get_name().decode("utf-8")
			}
			lst_addr.append(dict_addr)
		ret["candidates"].append(lst_addr)

	if sort_by_address_level:
		ret["candidates"] = sorted(ret["candidates"], key=_get_address_level, reverse=True)

	return ret

cpdef geocode_simplify(address, address_separator=""):
	"""
	execute geocoding request for specified address, then simplify candidates by concatenating address levels.
	:param address: refer to geocode() method
	:param sort_by_address_level: refer to geocode() method
	:return: refer to geocode() method
	"""
	ret = geocode(address)
	ret["candidates"] = [_concat_address(lst_dict_addr, address_separator) for lst_dict_addr in ret["candidates"]]

	return ret