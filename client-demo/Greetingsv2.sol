pragma solidity ^0.5.0;

contract Greetingsv2 {
    string public greeting;

    function Greeter() public {
        greeting = 'Hello';
    }

    function setGreeting(string memory _greeting) public {
        greeting = _greeting;
    }

    function getGreeting() public view returns (string memory) {
        return greeting;
    }
}