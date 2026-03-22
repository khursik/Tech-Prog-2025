#pragma once

#include <string>

// Interface for retrieving item prices.
class IPriceProvider {
public:
    virtual ~IPriceProvider() = default;

    // Returns the current price of an item by its name.
    // Throws std::runtime_error if the item is not found.
    virtual double get_price(const std::string& item) = 0;
};
