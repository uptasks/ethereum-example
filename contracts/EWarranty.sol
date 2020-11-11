// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

/**
 * EWarranty management in a blockchain
 */
contract EWarranty {
    string public organization;
    string public domain;
    address public owner;
    uint256 warrantiesCount = 0;
    uint256 claimsCount = 0;

    enum WARRANTY_STATUS {ACTIVE, INACTIVE}

    enum CLAIM_STATUS {PENDING, INPROGRESS, SETTLED, DISPUTED, CANCELLED}

    struct Customer {
        address account;
        string location;
        string city;
        string country;
    }

    struct ServiceCenter {
        string code;
        address incharged;
        string location;
        string city;
        string country;
    }

    struct Product {
        string sku;
        string name;
        uint256 price;
    }

    struct Warranty {
        uint256 id;
        Product product;
        Customer customer;
        uint256 start;
        uint256 expiry;
        WARRANTY_STATUS status;
        string terms;
    }

    struct Claim {
        uint256 id;
        address reportedBy;
        Warranty warranty;
        CLAIM_STATUS status;
    }

    mapping(address => Customer) public customers;
    mapping(string => Product) public products;
    mapping(uint256 => Warranty) warranties;
    mapping(uint256 => Claim) claims;
    mapping(string => ServiceCenter) serviceCenters;

    modifier isOwner {
        require(owner == msg.sender, "Only owner can perform this action");
        _;
    }

    constructor(string memory _organization, string memory _domain) public {
        require(bytes(_organization).length > 0, "_organization is required");
        require(bytes(_domain).length > 0, "_domain is required");

        organization = _organization;
        domain = _domain;
        owner = msg.sender;
    }

    function addProduct(
        string memory _sku,
        string memory _name,
        uint256 _price
    ) public isOwner {
        Product memory product = Product({
            sku: _sku,
            name: _name,
            price: _price
        });
        products[product.sku] = product;
    }

    function registerServiceCenter(
        string memory _code,
        address _incharged,
        string memory _location,
        string memory _city,
        string memory _country
    ) public isOwner {
        ServiceCenter memory serviceCenter = ServiceCenter({
            code: _code,
            incharged: _incharged,
            location: _location,
            city: _city,
            country: _country
        });
        serviceCenters[_code] = serviceCenter;
    }

    function registerWarranty(
        string memory _productSku,
        address _customerAddress,
        string memory _location,
        string memory _city,
        string memory _country,
        string memory _terms
    ) public isOwner {
        Product memory product = products[_productSku];
        Customer memory customer = Customer({
            account: _customerAddress,
            city: _city,
            location: _location,
            country: _country
        });

        warrantiesCount = warrantiesCount + 1;
        Warranty memory warranty = Warranty({
            id: warrantiesCount,
            product: product,
            customer: customer,
            start: 122,
            expiry: 123,
            terms: _terms,
            status: WARRANTY_STATUS.ACTIVE
        });
        warranties[warranty.id] = warranty;
        customers[customer.account] = customer;
    }

    function getWarranty(uint256 id) public view returns (Warranty memory) {
        return warranties[id];
    }

    function registerClaim(uint256 _warrantyID) public {
        Warranty memory warranty = warranties[_warrantyID];
        require(
            (warranty.customer.account == msg.sender || owner == msg.sender),
            "Only the admin or warranty owner can perform this action"
        );
        claimsCount = claimsCount + 1;
        Claim memory claim = Claim({
            id: claimsCount,
            warranty: warranty,
            reportedBy: msg.sender,
            status: CLAIM_STATUS.PENDING
        });
        claims[claimsCount] = claim;
    }

    function getClaim(uint256 id) public view returns (Claim memory) {
        return claims[id];
    }
}
