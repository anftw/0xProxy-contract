// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/**
  This contract adds an extra NFT security layer. It maps ownership address (that holds NFTs) to a usership address (that is granted utility by supported projects).
  The contract holds information about NFT addresses that can be used from the usership address.
  An usership address can be used to prove that an owner has some tokens without having to use the original owner's address to sign the proof.
  An usership address can NOT transfer NFTs.
  If a usership address wallet gets compromised it can be easily updated and ownership wallet stays safe!
*/
contract UsershipManager {
    using EnumerableSet for EnumerableSet.AddressSet;
    /**
      struct Usership holds information about which NFT contracts are allowed for a certain usership address
    */
    struct Usership {
        bool isOpen2All; // indicates if all NFT contracts are allowed
        address user; // usership account address
        EnumerableSet.AddressSet whitelist; // NFT contract addresses allowed for usership
    }

    mapping(address => Usership) private _userships; // an owner can have only one usership address (that can be modified if owner decides)
    mapping(address => address) public getOwnershipAddress; // a user can be assigned for only one owner

    /**
      Initialize usership for a owner wallet
      @param _allowFullTokenPermissions indicates if all NFT contracts are allowed for usership
      @param _newUsershipAddress new user wallet address
      @param _tokenAddressesPermitted NFT addresses which will be allowed for usership wallet to use
    */
    function setUsership(
        bool _allowFullTokenPermissions,
        address _newUsershipAddress,
        address[] calldata _tokenAddressesPermitted
    ) external {
        // usership address can't be used for multiple owners
        require(
            getOwnershipAddress[_newUsershipAddress] == address(0),
            "already_in_use"
        );
        Usership storage u = _userships[msg.sender];

        u.isOpen2All = _allowFullTokenPermissions;
        u.user = _newUsershipAddress;
        for (uint256 i = 0; i < _tokenAddressesPermitted.length; i++) {
            u.whitelist.add(_tokenAddressesPermitted[i]);
        }

        getOwnershipAddress[_newUsershipAddress] = msg.sender;
    }

    /**
      Get usership for provided owner address
      @param _owner owner wallet address
      @return fullPermission whether all NFT contracts are permitted
      @return usershipAddress usership wallet address
      @return tokensPermitted NFT contracts allowed to be used from the usership address
    */
    function getUsershipAddress(address _owner)
        public
        view
        returns (
            bool fullPermission,
            address usershipAddress,
            address[] memory tokensPermitted
        )
    {
        Usership storage u = _userships[_owner];

        tokensPermitted = new address[](u.whitelist.length());
        for (uint256 i = 0; i < u.whitelist.length(); i++) {
            tokensPermitted[i] = u.whitelist.at(i);
        }

        fullPermission = u.isOpen2All;
        usershipAddress = u.user;
    }

    /**
      Check if a NFT contract is allowed for a usership from a ownership wallet
      @param _usershipAddress usership account address
      @param _ownershipAddress ownership account address
      @param _tokenAddress NFT contract address
      @return tokenPermission wheather the permission exists
    */
    function getUsershipPermissionForOwnerToken(
        address _usershipAddress,
        address _ownershipAddress,
        address _tokenAddress
    ) external view returns (bool tokenPermission) {
        Usership storage u = _userships[_ownershipAddress];

        //case when the usership address is modified in the meantime
        if (u.user != _usershipAddress) {
            return false;
        }

        return u.isOpen2All || u.whitelist.contains(_tokenAddress);
    }

    /**
      Get informations assigned to a usership address
      @param _user usership account address
      @return fullPermission whether all NFT contracts are allowed to be used
      @return ownershipAddress the address linked to the provided usership address
      @return tokensPermitted the list of all allowed NFT contracts
    */
    function getUsershipPermissions(address _user)
        external
        view
        returns (
            bool fullPermission,
            address ownershipAddress,
            address[] memory tokensPermitted
        )
    {
        ownershipAddress = getOwnershipAddress[_user];
        (fullPermission, , tokensPermitted) = getUsershipAddress(
            ownershipAddress
        );
    }

    /**
      Check if the usership address has permission for a certain NFT contract
      @param _usershipAddress usership address
      @param _tokenAddress NFT contract address
      @return tokenPermission whether the permission exists
    */
    function getUsershipPermissionForToken(
        address _usershipAddress,
        address _tokenAddress
    ) external view returns (bool tokenPermission) {
        address ownershipAddress = getOwnershipAddress[_usershipAddress];
        if (ownershipAddress == address(0)) {
            return false;
        }

        Usership storage u = _userships[ownershipAddress];
        return u.isOpen2All || u.whitelist.contains(_tokenAddress);
    }

    /**
      Add or remove an NFT contract from the whitelist
      @param _tokenAddress NFT contract address
      @param _isAdd should the address be added or removed from the whitelist
    */
    function updateTokenPermission(address _tokenAddress, bool _isAdd)
        external
    {
        Usership storage u = _userships[msg.sender];

        if (_isAdd) {
            u.whitelist.add(_tokenAddress);
        } else {
            u.whitelist.remove(_tokenAddress);
        }
    }

    /**
      Update if all NFT addresses are allowed for usership
      @param _fullPermission indicates if all NFT contracts are allowed
    */
    function updateFullPermission(bool _fullPermission) external {
        Usership storage u = _userships[msg.sender];
        u.isOpen2All = _fullPermission;
    }
}
