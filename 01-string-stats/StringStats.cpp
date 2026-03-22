#include "StringStats.h"

#include <sstream>
#include <algorithm>
#include <cctype>

int StringStats::word_count(const std::string& s) {
    std::istringstream iss(s);
    std::string word;
    int count = 0;
    while (iss >> word) {
        count++;
    }
    return count;
}

int StringStats::longest_word_length(const std::string& s) {
    std::istringstream iss(s);
    std::string word;
    int max_len = 0;
    while (iss >> word) {
        if ((int)word.size() > max_len) {
            max_len = word.size();
        }
    }
    return max_len;
}

bool StringStats::is_all_digits(const std::string& s) {
    if (s.empty()) {
        return false;
    }
    for (char c : s) {
        if (c < '0' || c > '9') {
            return false;
        }
    }
    return true;
}

// Returns the string converted to lowercase.
std::string StringStats::to_lowercase(const std::string& s) {
    if (s.empty()) {
        return s;
    }
    std::string result = s;
    for (char& c : result) {
        c = std::tolower(c);
    }
    return result;
}

// Returns the number of unique words (case-insensitive).
int StringStats::unique_word_count(const std::string& s) {
    std::istringstream iss(s);
    std::string word;
    std::vector<std::string> seen;
    while (iss >> word) {
        std::string lower = to_lowercase(word);
        bool found = false;
        for (const auto& w : seen) {
            if (w == lower) {
                found = true;
                break;
            }
        }
        if (!found) {
            seen.push_back(lower);
        }
    }
    return seen.size();
}
