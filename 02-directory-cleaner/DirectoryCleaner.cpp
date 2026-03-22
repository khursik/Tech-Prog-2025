#include "DirectoryCleaner.h"

#include <stdexcept>

int DirectoryCleaner::count_files_recursive(const std::filesystem::path& dir) {
    if (!std::filesystem::exists(dir)) {
        throw std::invalid_argument("Path does not exist: " + dir.string());
    }
    if (!std::filesystem::is_directory(dir)) {
        throw std::invalid_argument("Path is not a directory: " + dir.string());
    }

    int count = 0;
    for (const auto& entry : std::filesystem::recursive_directory_iterator(dir)) {
        if (std::filesystem::is_regular_file(entry)) {
            count++;
        }
    }
    return count;
}

void DirectoryCleaner::remove_empty_subdirs(const std::filesystem::path& dir) {
    if (!std::filesystem::exists(dir)) {
        throw std::invalid_argument("Path does not exist: " + dir.string());
    }
    if (!std::filesystem::is_directory(dir)) {
        throw std::invalid_argument("Path is not a directory: " + dir.string());
    }

    for (const auto& entry : std::filesystem::directory_iterator(dir)) {
        if (std::filesystem::is_directory(entry)) {
            if (std::filesystem::is_empty(entry)) {
                std::filesystem::remove(entry);
            }
        }
    }
}

bool DirectoryCleaner::is_empty_dir(const std::filesystem::path& dir) {
    if (!std::filesystem::exists(dir) || !std::filesystem::is_directory(dir)) {
        return false;
    }
    return std::filesystem::is_empty(dir);
}
