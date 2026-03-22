#pragma once

#include <gtest/gtest.h>
#include <filesystem>
#include <fstream>
#include "DirectoryCleaner.h"

class DirectoryCleanerTest : public ::testing::Test {
protected:
    std::filesystem::path temp_dir_;
    DirectoryCleaner cleaner_;

    void SetUp() override {
        temp_dir_ = std::filesystem::temp_directory_path() / "dir_cleaner_test";
        std::filesystem::create_directories(temp_dir_);
    }

    void TearDown() override {
        std::filesystem::remove_all(temp_dir_);
    }
};
