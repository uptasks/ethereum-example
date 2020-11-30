// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

contract DocuSign {
    address public owner;
    uint public numOfDocuments=0;
    
    struct Account {
        address owner;
        string ext_identifier_url;
    }
    
    enum Status {
        PENDING,
        APPROVE,
        DECLINED
    }
    
    struct Signer {
        Account account;
        Status status;
    }
    
    struct Document {
        mapping(address=>Account) publisher;
        mapping(address => Signer) signers;
        string path;
        uint expectedSignatures;
        uint signatureCounts;
    }
    
    mapping(uint=>Document) public documents;
    mapping(address=>Account) public accounts;
    
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
    
    function register(string memory _ext_identifier_url) public {
        accounts[msg.sender]=Account({owner: msg.sender, ext_identifier_url: _ext_identifier_url});
    }
    
    function addDocument(string memory _path, address[] memory _signers) public {
        require(bytes(_path).length > 0, "Path is required");
        require(_signers.length > 0, "Signers list is required");
        
        Account memory publisher_account = accounts[msg.sender];
        
        Document storage document = documents[numOfDocuments];
        document.publisher[msg.sender] = publisher_account;
        document.path = _path;
        document.expectedSignatures = _signers.length;
        numOfDocuments = numOfDocuments + 1;
        
        for (uint i = 0; i < _signers.length; i++) {
            Account memory account = accounts[_signers[i]];
            document.signers[_signers[i]]=Signer({account: account, status: Status.PENDING});
        }
    }
    
    function addSigner(uint _documentID) public isOwner {
        
    }
     function removeSigner(uint _documentID) public isOwner {
        
    }
    
    function approve(uint _documentID) public {
        Document storage document = documents[_documentID];
        require(document.signers[msg.sender].account.owner == msg.sender, "Not allowed signer");
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
        require(document.signers[msg.sender].account.owner == msg.sender, "Not allowed signer");
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