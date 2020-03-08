pragma solidity ^0.5.16;

contract Election{
    // store the candidates
    // provide reading and writing

    // string public candidate;

    // model a candidate
    struct Candidate {
        // unsigned integer
        uint id;
        string name;
        uint voteCount;
    }

    // key => value to store the candidates
    mapping (uint => Candidate) public candidates;

    // Store accounts that have voted
    mapping (address => bool) public voters;

    // to count the number, since mapping has no function of counting
    // brutely
    uint public candidatesCount;

    // constraint the range of candidates
    constructor() public {
        addCandidate("cand 1");
        addCandidate("cand 2");
    }

    // here memory is mandatory to tell the location of the parameter
    function addCandidate(string memory _name) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    // voted event
    event votedEvent (
        uint indexed _candidateId
    );

    function vote (uint _candidateId) public {
        // check if the voter has voted    
        require(!voters[msg.sender]);

        // check if the candidate is valid
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        // vote for a candidate and update its count
        candidates[_candidateId].voteCount ++;

        // record the voter has votes
        // how to know who's voter??? why should we know?
        // however this is the voter
        // voters[msg.sender] = true;

        // trigger voted event
        emit votedEvent(_candidateId);
    }
}