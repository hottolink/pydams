///
/// @file
/// @brief damsをラップするstatic関数群
///

#ifndef _DAMS_H
#define _DAMS_H

#include <string>
#include <vector>
#include <stdexcept>

extern "C" {
  int dams_is_present(void);
}

namespace damswrapper { 
	
  ///
  /// @file
  /// @brief dams実行結果の住所要素
  ///
  class AddressElement {
  private:
		
    std::string name;
		
    int level;
		
    float x;
		
    float y;
		
  public:
		
  AddressElement() : level(0), x(0.0), y(0.0) {}
		
    inline std::string get_name() const {
      return name;
    }
		
    inline void set_name(std::string v) {
      name = v;
    }
		
    inline int get_level() const {
      return level;
    }
		
    inline void set_level(int v) {
      level = v;
    }
		
    inline float get_x() const {
      return x;
    }
		
    inline void set_x(float v) {
      x = v;
    }
		
    inline float get_y() const {
      return y;
    }
		
    inline void set_y(float v) {
      y = v;
    }
  };

  ///
  /// @file
  /// @brief damsの例外クラス。
  ///
  class DamsInitException : public std::runtime_error {
  public:
  DamsInitException(const char* msg) : runtime_error(msg) {}
  };
	
  class DamsException : public std::runtime_error {
  public:
  DamsException(const char* msg) : runtime_error(msg) {}
  };

  void unexpectedHandler(){
    std::string msg = "caught unexpected exception.";
    throw DamsException(msg.c_str());
  };

  typedef std::vector<AddressElement> Candidate;
	
  /// @brief 初期化します。
  /// @param [in] damsFileName 辞書ファイル名
  /// @exception ファイルが開けないなど、初期化に失敗した場合
  void init(const std::string& damsFileName) throw (DamsInitException);

  /// @brief デフォルトのジオコーダファイルが存在すれば開いて初期化します。
  void init(void);

  /// @brief ジオコーダファイルを開かずに初期化します。
  void _init(void);

  /// @brief initialize geocoder with exception handler
  void init_safe(void){
    std::set_unexpected(unexpectedHandler);
    init();
  }
  void init_safe(const std::string& damsFileName){
    std::set_unexpected(unexpectedHandler);
    init(damsFileName);
  }

  /// @brief 終了します。
  void final();

  /// @brief デフォルトの辞書ディレクトリを返します。
  const char* default_dic_path(void);

  /// @brief 文字コードを変換します。
  std::string utf8_to_euc(const std::string& utf_string);
  std::string euc_to_utf8(const std::string& euc_string);
	
  /// @brief 解析して結果を返します。
  /// @param [out] score
  /// @param [out] tail
  /// @param [out] candidates
  /// @param [in] クエリ文字列。UTF-8の文字列である必要がある。
  void retrieve(
		int& score, 
		std::string& tail, 
		std::vector<Candidate>& candidates, 
		const std::string& query) throw (DamsException);
    // const std::string& query);
	
  /// @brief デバッグモードに設定します。初期化後の呼び出しのみ有効です。デフォルト値false
  /// @param [in] flag
  void debugmode(bool flag);
	
  /// @brief 新地名をチェックするかどうかを設定します。初期化後の呼び出しのみ有効です。デフォルト値false
  /// @param [in] flag
  void set_check_new_address(bool flag);
	
  /// @brief 検索する件数の上限を設定します。初期化後の呼び出しのみ有効です。デフォルト値10
  /// @param [in] limit
  void set_limit(int limit);
	
  /// @brief 完全一致を必要とするレベルを設定します。初期化後の呼び出しのみ有効です。デフォルト値5
  /// @param [in] level
  void set_exact_match_level(int level);
	
  /// @brief 完全一致を必要とするレベルを取得します。
  /// @return
  int get_exact_match_level();
	
  /// @brief 最後の retrieve() に要した時間（ミリ秒）を取得します。
  /// @return
  long elapsedtime();

  /// @brief 異体字を標準化した文字列を取得します。
  /// @param [in] str 異体字を含む文字列
  /// @return 標準化文字列
  std::string get_standardized_string(const std::string& str);  
}

#endif /* _DAMS_H */
