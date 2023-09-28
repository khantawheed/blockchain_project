// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract DataStorage {
    struct Access {
        address user;
        bool hasAccess;
    }
    
    struct DataItem {
        string url;
        string[] keywords;
    }
    
    mapping(address => DataItem[]) private data; // Store data items associated with keywords
    mapping(address => mapping(address => bool)) private accessMapping;
    mapping(address => Access[]) private accessList;
    mapping(address => mapping(address => bool)) private hasPreviousAccess;

    function addData(string memory _url, string[] memory _keywords) external {
        data[msg.sender].push(DataItem(_url, _keywords));
    }

    function grantAccess(address _user) external {
        accessMapping[msg.sender][_user] = true;
        if (hasPreviousAccess[msg.sender][_user]) {
            for (uint256 i = 0; i < accessList[msg.sender].length; i++) {
                if (accessList[msg.sender][i].user == _user) {
                    accessList[msg.sender][i].hasAccess = true;
                }
            }
        } else {
            accessList[msg.sender].push(Access(_user, true));
            hasPreviousAccess[msg.sender][_user] = true;
        }
    }

    function revokeAccess(address _user) public {
        accessMapping[msg.sender][_user] = false;
        for (uint256 i = 0; i < accessList[msg.sender].length; i++) {
            if (accessList[msg.sender][i].user == _user) {
                accessList[msg.sender][i].hasAccess = false;
            }
        }
    }

    function searchData(string memory _keyword) external view returns (string[] memory) {
    // Create a dynamic array to store matching URLs
    string[] memory matchingURLs = new string[](data[msg.sender].length);

    uint256 count = 0;
    for (uint256 i = 0; i < data[msg.sender].length; i++) {
        DataItem storage item = data[msg.sender][i];
        for (uint256 j = 0; j < item.keywords.length; j++) {
            if (keccak256(bytes(item.keywords[j])) == keccak256(bytes(_keyword))) {
                // Store the matching URL in the dynamic array in memory
                matchingURLs[count] = item.url;
                count++;
                break; // Exit the inner loop when a match is found
            }
        }
    }

    // Create a new array with the correct length
    string[] memory result = new string[](count);
    for (uint256 i = 0; i < count; i++) {
        result[i] = matchingURLs[i];
    }

    return result;
}

    function getSharedAccess() public view returns (Access[] memory) {
        return accessList[msg.sender];
    }
}
