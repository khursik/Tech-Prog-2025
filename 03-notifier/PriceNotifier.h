#pragma once

#include <string>
#include <vector>
#include "IPriceProvider.h"

// Price analyzer: accepts an IPriceProvider and produces comparison reports.
class PriceNotifier {
public:
    explicit PriceNotifier(IPriceProvider* provider);

    // Returns a string of the form:
    //   "item1 is cheaper than item2 by N руб."       — if item1 is cheaper
    //   "item1 is more expensive than item2 by N руб." — if item1 is more expensive
    //   "item1 and item2 have the same price"          — if prices are equal
    // N is an integer (price difference truncated toward zero).
    std::string compare(const std::string& item1, const std::string& item2);

    // Returns true if the item's price exceeds threshold.
    bool is_expensive(const std::string& item, double threshold);

    // Returns the average price over a list of items.
    // Throws std::invalid_argument if the list is empty.
    double average_price(const std::vector<std::string>& items);

private:
    IPriceProvider* provider_;
};
