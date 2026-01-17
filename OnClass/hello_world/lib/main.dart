void main() {
  print("Hello, World.");
  //1.
  var arr = [1, 2, 3, 4, 5, 6, 10, 7];
  var result = arr.where((x) => x % 2 == 0).map((n) => n * 2).toList();
  result.forEach((x) => print(x));

  //2.
  final time = DateTime.now();
  const double PI = 3.14;
  print(
    '${time.day.toString().padLeft(2, '0')}/'
    '${time.month.toString().padLeft(2, '0')}/'
    '${time.year} - $PI',
  );

  //3. Dao nguoc chuoi
  String str = "Hello world!";
  String re = str.split(' ').reversed.join(" ");
  print(re);

  /*
====================================================
1. VALID ANAGRAM
----------------------------------------------------
Requirement:
- Write a function that takes two strings and returns true
  if they are anagrams (same characters with same frequency).

Input:
- String s, String t

Test Cases:
- s = "anagram", t = "nagaram" -> true
- s = "rat", t = "car" -> false
====================================================
*/
  String s = "anagram";
  String t = "nagara";
  if (s.length != t.length) print("Not a param.");

  final map = <String, int>{};

  for (var ch in s.split('')) {
    map[ch] = (map[ch] ?? 0) + 1;
  }
  for (var ch in t.split('')) {
    if (!map.containsKey(ch)) {
      print("Not a param.");
      break;
    }
    map[ch] = map[ch]! - 1;
    if (map[ch] == 0) map.remove(ch);
  }
  if (map.isEmpty)
    print("Is a param.");
  else
    print("Not a param.");

  /*
====================================================
2. MAJORITY ELEMENT
----------------------------------------------------
Requirement:
- Given a List<int>, find the element that appears
  more than n / 2 times.
- Assume the majority element always exists.

Input:
- List<int> nums

Test Cases:
- [3, 2, 3] -> 3
- [2, 2, 1, 1, 1, 2, 2] -> 2
====================================================
*/
  int majorityElement(List<int> nums) {
    int count = 0;
    int? candidate;

    for (var num in nums) {
      if (count == 0) candidate = num;
      count += (num == candidate) ? 1 : -1;
    }
    return candidate!;
  }

  print(majorityElement([3, 2, 3])); // 3
  print(majorityElement([2, 2, 1, 1, 1, 2, 2])); // 2
  /*
====================================================
3. BEST TIME TO BUY AND SELL STOCK
----------------------------------------------------
Requirement:
- prices[i] represents the stock price on day i.
- Return the maximum profit you can achieve by
  buying on one day and selling on a future day.
- If no profit is possible, return 0.

Input:
- List<double> prices

Test Cases:
- [7, 1, 5, 3, 6, 4] -> 5 (Buy at 1, sell at 6)
- [7, 6, 4, 3, 1] -> 0
====================================================
*/
  double maxProfit(List<double> prices) {
    double minPrice = double.infinity;
    double maxProfit = 0;

    for (var p in prices) {
      if (p < minPrice)
        minPrice = p;
      else if (p - minPrice > maxProfit)
        maxProfit = p - minPrice;
    }
    return maxProfit;
  }

  print(maxProfit([7, 1, 5, 3, 6, 4])); // 5
  print(maxProfit([7, 6, 4, 3, 1])); // 0
  /*
====================================================
4. ARRAY FLATTENING
----------------------------------------------------
Requirement:
- Write a function to flatten a nested list of integers
  into a single list.
- Use recursion.

Input:
- [1, [2, 3], [4, [5, 6]]]

Output:
- [1, 2, 3, 4, 5, 6]
====================================================
*/
  List<int> flatten(List<dynamic> list) {
    List<int> result = [];
    for (var item in list) {
      if (item is int) {
        result.add(item);
      } else if (item is List) {
        result.addAll(flatten(item));
      }
    }
    return result;
  }

  print(
    flatten([
      1,
      [2, 3],
      [
        4,
        [5, 6],
      ],
    ]),
  );
  // [1,2,3,4,5,6]
  /*
====================================================
5. GROUP ANAGRAMS
----------------------------------------------------
Requirement:
- Given a List<String>, group the anagrams together.

Input:
- ["eat", "tea", "tan", "ate", "nat", "bat"]

Output:
- [["eat", "tea", "ate"], ["tan", "nat"], ["bat"]]

Hint:
- Use a Map<String, List<String>>.
====================================================
*/
  List<List<String>> groupAnagrams(List<String> words) {
    final map = <String, List<String>>{};

    for (var w in words) {
      var key = (w.split('')..sort()).join();
      map.putIfAbsent(key, () => []).add(w);
    }

    return map.values.toList();
  }

  print(groupAnagrams(["eat", "tea", "tan", "ate", "nat", "bat"]));
  // [["eat","tea","ate"], ["tan","nat"], ["bat"]]
  /*
====================================================
6. MISSING NUMBER
----------------------------------------------------
Requirement:
- Given an array nums containing n distinct numbers
  in the range [0, n], return the only number missing
  from the array.

Input & Expected Output:
- [3, 0, 1] -> 2
- [0, 1] -> 2
- [9, 6, 4, 2, 3, 5, 7, 0, 1] -> 8
====================================================
*/
  int missingNumber(List<int> nums) {
    int sum1 = 0;
    int sum2 = 0;
    for (int i = 0; i < nums.length; i++) {
      sum1 += i;
      sum2 += nums[i];
    }
    return sum1 + nums.length - sum2;
  }

  print(missingNumber([3, 0, 1])); // 2
  print(missingNumber([0, 1])); // 2
  print(missingNumber([9, 6, 4, 2, 3, 5, 7, 0, 1])); // 8
  /*
====================================================
7. RUN-LENGTH ENCODING
----------------------------------------------------
Requirement:
- Compress a string by replacing repeated characters
  with the character followed by the count.

Input:
- "aaabbcdddd" -> "a3b2c1d4"
- "abcd" -> "a1b1c1d1"
====================================================
*/

  String str1 = "abcd";
  Map<String, int> dict = {};
  for (int i = 0; i < str1.length; i++) {
    dict[str1[i]] = (dict[str1[i]] ?? 0) + 1;
  }
  String x = '';
  dict.forEach((key, value) {
    x += '$key$value';
  });
  print(x);
  /*
====================================================
8. LIST CHUNKING
----------------------------------------------------
Requirement:
- Write a function that splits a list into sub-lists
  of a specified size.

Input:
- list = [1, 2, 3, 4, 5], size = 2
  -> [[1, 2], [3, 4], [5]]

- list = [1, 2, 3], size = 5
  -> [[1, 2, 3]]
====================================================
*/
  List<List<T>> chunk<T>(List<T> list, int size) {
    List<List<T>> result = [];
    for (int i = 0; i < list.length; i += size) {
      int end = (i + size < list.length) ? i + size : list.length;
      result.add(list.sublist(i, end));
    }
    return result;
  }

  print(chunk([1, 2, 3, 4, 5], 2)); // [[1,2], [3,4], [5]]
  print(chunk([1, 2, 3], 5)); // [[1,2,3]]
  /*
====================================================
9. FIBONACCI SEQUENCE (NON-RECURSIVE)
----------------------------------------------------
Requirement:
- Generate the first n numbers of the Fibonacci sequence
  using a loop.

Input:
- n = 6

Output:
- [0, 1, 1, 2, 3, 5]
====================================================
*/
  List<int> fibonacci(int n) {
    if (n <= 0) return [];
    if (n == 1) return [0];

    List<int> result = [0, 1];
    for (int i = 2; i < n; i++) {
      result.add(result[i - 1] + result[i - 2]);
    }
    return result;
  }

  print(fibonacci(6)); // [0,1,1,2,3,5]
  /*
====================================================
10. FILTER & TRANSFORM JSON-LIKE MAP
----------------------------------------------------
Requirement:
- Given a list of user maps, return a list of names (String)
  of users who are older than 18 and have the "admin" role.
- Use functional methods (.where, .map).

Input:
List<Map<String, dynamic>> users = [
  {'name': 'Alice', 'age': 25, 'role': 'admin'},
  {'name': 'Bob', 'age': 17, 'role': 'admin'},
  {'name': 'Charlie', 'age': 30, 'role': 'user'},
  {'name': 'David', 'age': 20, 'role': 'admin'},
];

Output:
- ["Alice", "David"]
====================================================
*/
  List<String> filterAdmins(List<Map<String, dynamic>> users) {
    return users
        .where((u) => u['age'] > 18 && u['role'] == 'admin')
        .map((u) => u['name'] as String)
        .toList();
  }

  List<Map<String, dynamic>> users = [
    {'name': 'Alice', 'age': 25, 'role': 'admin'},
    {'name': 'Bob', 'age': 17, 'role': 'admin'},
    {'name': 'Charlie', 'age': 30, 'role': 'user'},
    {'name': 'David', 'age': 20, 'role': 'admin'},
  ];

  print(filterAdmins(users)); // ["Alice", "David"]
  //
  // runApp(
  //   const Center(
  //     child: Text(
  //       'Hello, Duc!',
  //       textDirection: TextDirection.rtl,
  //       style: TextStyle(color: Colors.pinkAccent),
  //     ),
  //   ),
  // );
}
