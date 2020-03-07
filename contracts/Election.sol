pragma solidity ^0.5.16;

contract Election{
    // store the candidates
    // provide reading and writing

    // string public candidate;

    // // constructor
    // constructor() public {
    //     // underline means state variable
    //     candidate = "cand1";
    // }

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
        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;

        // trigger voted event
        emit votedEvent(_candidateId);
    }
}