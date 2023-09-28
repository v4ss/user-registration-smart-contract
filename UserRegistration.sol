// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title UserRegistration
 * @author v4ss | Florian ALLIONE
 * @notice Store, retrieve, count and delete values of users
 */
contract UserRegistration {

    address public owner;

    struct User {
        string name;
        address userAddress;
    }

    User[] private users;

    constructor() {
        /// Define the owner of the contract
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Your are not able to do this action");
        _;
    }

    /**
     * @notice Changes the owner address
     * @dev Only for owner
     */
    function changeOwnerAdress(address ownerAddress) public onlyOwner {
        owner = ownerAddress;
    }

    /**
     * @notice Find the index of the current user in the users array
     * @param userAddress value of the current user address
     * @return i value of the index
     */
    function findUserIndex(address userAddress) private view returns (uint256) {
        for(uint256 i = 0 ; i < users.length ; i++) {
            if(users[i].userAddress == userAddress) {
                return i;
            }
        }
        /// Impossible value for indicate that the user isn't register in the array
        return type(uint256).max;
    }

    /**
     * @notice Register the name of users
     * @param name value to set name of the user
     */
    function setName(string memory name) public {
        User memory newUser;
        newUser.name = name;
        newUser.userAddress = msg.sender;

        /// Push the identity in the users array
        users.push(newUser);
    }

    /**
     * @notice Add a list of users in the array
     * @dev Only for owner
     */
    function registerUserList(User[] memory userList) public onlyOwner {
        for(uint256 i = 0 ; i < userList.length ; i++) {
            users.push(userList[i]);
        }
    }

    /**
     * @notice Returns the name of the current user 
     * @return value of 'users.name'
     */
    function getName() public view returns (string memory){
        uint256 index = findUserIndex(msg.sender);

        /// If the user exists in the array (cf. findUserIndex function)
        if(index != type(uint256).max) {
            return users[index].name;
        }
        /// Else
        return "";
    }

    /**
     * @notice Returns the count of users registered
     * @return count of users
     */
    function getUserCount() public view returns (uint256) {
        return users.length;
    }

    /**
     * @notice Delete the registration of the current user
     */
    function deleteUser() public {
        uint256 lastIndex = users.length - 1;
        uint256 index = findUserIndex(msg.sender);
        /// User must exist (cf. findUserIndex function)
        require(index != type(uint256).max, "User not found");

        /// Replaces the deleted user by the last
        if(index != lastIndex) {
            users[index] = users[lastIndex];
        }

        /// Ejects the copy or the deleted user if he is the last
        users.pop();
    }

    /**
     * @notice Deletes the registration of a particular user
     * @dev Only for owner
     */
    function deleteUserByAddress (address userAddress) public onlyOwner {
        uint256 lastIndex = users.length - 1;
        uint256 index = findUserIndex(userAddress);
        /// User must exist (cf. findUserIndex function)
        require(index != type(uint256).max, "User not found");

        /// Replaces the deleted user by the last
        if(index != lastIndex) {
            users[index] = users[lastIndex];
        }

        /// Ejects the copy or the deleted user if he is the last
        users.pop();
    }

    /**
     * @notice Get all registered users
     * @dev Only for owner
     * @return users the array of all users
     */
    function getUsers() public view onlyOwner returns(User[] memory) {
        return users;
    }
}
