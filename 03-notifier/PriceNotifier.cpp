#include "PriceNotifier.h"

#include <sstream>
#include <stdexcept>
#include <vector>
#include <cmath>

PriceNotifier::PriceNotifier(IPriceProvider* provider)
    : provider_(provider) {}

std::string PriceNotifier::compare(const std::string& item1, const std::string& item2) {
    double price1 = provider_->get_price(item1);
    double price2 = provider_->get_price(item2);

    std::ostringstream out;
    double diff = price1 - price2;

    if (std::abs(diff) < 0.01) {
        out << item1 << " and " << item2 << " have the same price";
    } else if (diff < 0) {
        out << item1 << " is cheaper than " << item2 << " by " << (int)std::abs(diff) << " руб.";
    } else {
        out << item1 << " is more expensive than " << item2 << " by " << (int)diff << " руб.";
    }

    return out.str();
}

bool PriceNotifier::is_expensive(const std::string& item, double threshold) {
    return provider_->get_price(item) > threshold;
}

double PriceNotifier::average_price(const std::vector<std::string>& items) {
    if (items.empty()) {
        throw std::invalid_argument("Item list must not be empty");
    }
    double sum = 0.0;
    for (const auto& item : items) {
        sum += provider_->get_price(item);
    }
    return sum / items.size();
}
