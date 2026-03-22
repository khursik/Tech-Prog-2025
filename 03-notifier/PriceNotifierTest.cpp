#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include "MockPriceProvider.h"
#include "PriceNotifier.h"

using ::testing::Return;
using ::testing::NiceMock;

// TODO: write tests for all methods of PriceNotifier.
// Read PriceNotifier.cpp and think about which code branches need to be covered.
//
// Example test structure:
//   NiceMock<MockPriceProvider> mock;
//   ON_CALL(mock, get_price("milk")).WillByDefault(Return(50.0));
//   PriceNotifier notifier(&mock);
//   EXPECT_EQ("...", notifier.compare(...));
