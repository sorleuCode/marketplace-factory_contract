// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library ReUsables {
    enum Status {
        None,
        Created,
        Pending,
        Soldout
    }

    struct Asset {
        string name;
        uint16 price;
        Status status;
    }

}