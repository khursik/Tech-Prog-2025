#pragma once

#include <string>
#include <vector>

class StringStats {
public:
    // Returns the number of words in the string (words separated by spaces).
    // Multiple consecutive spaces count as a single separator.
    // Empty string returns 0.
    int word_count(const std::string& s);

    // Returns the length of the longest word in the string.
    // Returns 0 for an empty string.
    int longest_word_length(const std::string& s);

    // Returns true if the string is non-empty and consists only of digits.
    bool is_all_digits(const std::string& s);

    // Returns the string converted to lowercase.
    // Returns an empty string for an empty input.
    std::string to_lowercase(const std::string& s);

    // Returns the number of unique words (case-insensitive).
    // "Hello hello HELLO" counts as 1 unique word.
    // Empty string returns 0.
    int unique_word_count(const std::string& s);
};
