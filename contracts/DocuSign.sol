// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

contract DocuSign {
    address public owner;
    uint public numOfDocuments=0;
    
    
    enum Status {
        PENDING,
        APPROVE,
        DECLINED
    }
    
    struct Signer {
        address account;
        Status status;
    }
    
    struct Document {
        address publisher;
        mapping(address => Signer) signers;
        string path;
        uint expectedSignatures;
        uint signatureCounts;
    }
    
    mapping(uint=>Document) public documents;
    mapping(uint=>address) public publishers;
    
    modifier isOwner {
        require(owner==msg.sender, "Only owner can perform this action");
        _;
    }
    
    event DocumentCompleted(uint document_id);
    event DocumentApproved(uint document_id, address peformed_by);
    event DocumentDeclined(uint document_id, address peformed_by);
     
    constructor() {
        owner = msg.sender;
    }
    
    
    function addDocument(string memory _path, address[] memory _signers) public {
        require(bytes(_path).length > 0, "Path is required");
        require(_signers.length > 0, "Signers list is required");
        
        Document storage document = documents[numOfDocuments];
        document.publisher = msg.sender;
        document.path = _path;
        document.expectedSignatures = _signers.length;
        numOfDocuments = numOfDocuments + 1;
        
        for (uint i = 0; i < _signers.length; i++) {
            document.signers[_signers[i]]=Signer({account: _signers[i], status: Status.PENDING});
        }
    }
    
    function addSigner(uint _documentID, address _new_signer_addr) public {
        Document storage document = documents[_documentID];
        require(document.publisher == msg.sender, "Only document owner can perform this action");
        require(document.expectedSignatures > document.signatureCounts, "Signing of the document already completed");
        
        document.signers[_new_signer_addr]=Signer({account: _new_signer_addr, status: Status.PENDING});
    }
     function removeSigner(uint _documentID, address _addr_to_remove) public  {
        Document storage document = documents[_documentID];
        require(document.publisher == msg.sender, "Only document owner can perform this action");
        require(document.expectedSignatures > document.signatureCounts, "Signing of the document already completed");
        delete document.signers[_addr_to_remove];
    }
    
    function approve(uint _documentID) public {
        Document storage document = documents[_documentID];
        require(document.signers[msg.sender].account == msg.sender, "Not allowed signer");
        require(document.signers[msg.sender].status == Status.PENDING, "You have already performed action on the document");
        require(document.expectedSignatures > document.signatureCounts, "All actions already taken on document");
        document.signers[msg.sender].status = Status.APPROVE;
        document.signatureCounts = document.signatureCounts+1;
        
        emit DocumentApproved(_documentID, msg.sender);
        if (document.expectedSignatures == document.signatureCounts) {
           emit DocumentCompleted(_documentID);
        }
    }
    
    function decline(uint _documentID) public {
        Document storage document = documents[_documentID];
        require(document.signers[msg.sender].account == msg.sender, "Not allowed signer");
        require(document.signers[msg.sender].status == Status.PENDING, "You have already performed action on the document");
        require(document.expectedSignatures > document.signatureCounts, "All actions already taken on document");
        document.signers[msg.sender].status = Status.DECLINED;
        document.signatureCounts = document.signatureCounts+1;
        
        emit DocumentDeclined(_documentID, msg.sender);
        if (document.expectedSignatures == document.signatureCounts) {
          emit DocumentCompleted(_documentID);
        }
    }
}