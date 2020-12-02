// SPDX-License-Identifier: MIT

pragma solidity 0.5.16;

contract DecentraDocuSign {
    address public owner;
    address payable public supportAddress = 0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1;
    uint public signersCount =0;
    uint public signatureCount =0;
    bool public completed = false;
    
    enum Status {
        PENDING,
        APPROVED,
        DECLINED
    }
    
    struct Signature {
        address owner;
        Status status;
        bool exists;
    }
    
    struct Document {
        string path;
    }
    
    Document public document;
    mapping(address=>Signature) public signatures;
    address[] public signers;
    
    modifier isOwner {
        require(owner==msg.sender, "Only owner can perform this action");
        _;
    }
    
    event DocumentAdded(string path);
    event DocumentCompleted(string path);
    event DocumentApproved(string path, address peformed_by);
    event DocumentDeclined(string path, address peformed_by);
     
    constructor(string memory _path, address[] memory _signers) payable public {
        owner = msg.sender;
        supportAddress.transfer(msg.value);
        document = Document({path:_path});
        for(uint i=0; i<_signers.length; i++) {
            signatures[_signers[i]] = Signature({owner: _signers[i], status: Status.PENDING, exists: true});
        }
        signersCount = _signers.length;
        signers = _signers;
        emit DocumentAdded(_path);
    }
    
    function approve() public {
        require(signatures[msg.sender].status == Status.PENDING, "You are not eligible or you have already performed this action");
        signatures[msg.sender].status = Status.APPROVED;
        signatureCount = signatureCount + 1;
        if (signatureCount == signersCount) {
            completed = true;
            emit DocumentCompleted(document.path);
        }
        
    }
    
    function decline() public {
        require(signatures[msg.sender].status == Status.PENDING, "You are not eligible or you have already performed this action");
        signatures[msg.sender].status = Status.DECLINED;
        signatureCount = signatureCount + 1;
        if (signatureCount == signersCount) {
            completed = true;
            emit DocumentCompleted(document.path);
        }
    }
    
    function addSigner(address _new_signer_addr) public isOwner {
        require(!signatures[_new_signer_addr].exists, "Participant already exists");
        signatures[_new_signer_addr] = Signature({owner:_new_signer_addr,status: Status.PENDING, exists: true}); 
    }
    
    function removeSigner(address _addr_to_remove) public isOwner {
        require(signatures[_addr_to_remove].exists, "Address must be exist in signature list");
        require(signatures[_addr_to_remove].status == Status.PENDING, "Not allowed to remove address. User has already participated");
        delete signatures[_addr_to_remove];
    }
}// SPDX-License-Identifier: MIT

pragma solidity 0.5.16;

contract DecentraDocuSign {
    address public owner;
    address payable public supportAddress = 0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1;
    uint public signersCount =0;
    uint public signatureCount =0;
    bool public completed = false;
    
    enum Status {
        PENDING,
        APPROVED,
        DECLINED
    }
    
    struct Signature {
        address owner;
        Status status;
        bool exists;
    }
    
    struct Document {
        string path;
    }
    
    Document public document;
    mapping(address=>Signature) public signatures;
    address[] public signers;
    
    modifier isOwner {
        require(owner==msg.sender, "Only owner can perform this action");
        _;
    }
    
    event DocumentAdded(string path);
    event DocumentCompleted(string path);
    event DocumentApproved(string path, address peformed_by);
    event DocumentDeclined(string path, address peformed_by);
     
    constructor(string memory _path, address[] memory _signers) payable public {
        owner = msg.sender;
        supportAddress.transfer(msg.value);
        document = Document({path:_path});
        for(uint i=0; i<_signers.length; i++) {
            signatures[_signers[i]] = Signature({owner: _signers[i], status: Status.PENDING, exists: true});
        }
        signersCount = _signers.length;
        signers = _signers;
        emit DocumentAdded(_path);
    }
    
    function approve() public {
        require(signatures[msg.sender].status == Status.PENDING, "You are not eligible or you have already performed this action");
        signatures[msg.sender].status = Status.APPROVED;
        signatureCount = signatureCount + 1;
        if (signatureCount == signersCount) {
            completed = true;
            emit DocumentCompleted(document.path);
        }
        
    }
    
    function decline() public {
        require(signatures[msg.sender].status == Status.PENDING, "You are not eligible or you have already performed this action");
        signatures[msg.sender].status = Status.DECLINED;
        signatureCount = signatureCount + 1;
        if (signatureCount == signersCount) {
            completed = true;
            emit DocumentCompleted(document.path);
        }
    }
    
    function addSigner(address _new_signer_addr) public isOwner {
        require(!signatures[_new_signer_addr].exists, "Participant already exists");
        signatures[_new_signer_addr] = Signature({owner:_new_signer_addr,status: Status.PENDING, exists: true}); 
    }
    
    function removeSigner(address _addr_to_remove) public isOwner {
        require(signatures[_addr_to_remove].exists, "Address must be exist in signature list");
        require(signatures[_addr_to_remove].status == Status.PENDING, "Not allowed to remove address. User has already participated");
        delete signatures[_addr_to_remove];
    }
}