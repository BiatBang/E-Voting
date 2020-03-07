pragma solidity ^0.5.16;

contract Election{
    // store the candidates
    // provide reading and writing

    string public candidate;

    // constructor
    constructor() public {
        // underline means state variable
        candidate = "cand1";
    }

}