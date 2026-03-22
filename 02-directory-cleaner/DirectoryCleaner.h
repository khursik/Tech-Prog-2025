#pragma once

#include <filesystem>
#include <string>

// Utility for working with directories.
class DirectoryCleaner {
public:
    // Recursively counts files in a directory (does not count subdirectories themselves).
    // Throws std::invalid_argument if the path does not exist or is not a directory.
    int count_files_recursive(const std::filesystem::path& dir);

    // Removes empty subdirectories inside dir (one level deep only). Does not remove dir itself.
    // Throws std::invalid_argument if dir does not exist or is not a directory.
    void remove_empty_subdirs(const std::filesystem::path& dir);

    // Returns true if the directory exists and contains no files or subdirectories.
    bool is_empty_dir(const std::filesystem::path& dir);
};
