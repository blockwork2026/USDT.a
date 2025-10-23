// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0 and Community Contracts commit b0ddd27
pragma solidity ^0.8.27;

import {ERC1363} from "@openzeppelin/contracts/token/ERC20/extensions/ERC1363.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Bridgeable} from "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Bridgeable.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Custodian} from "@openzeppelin/community-contracts/token/ERC20/extensions/ERC20Custodian.sol";
import {ERC20FlashMint} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20FlashMint.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @custom:security-contact ahamadwork2026@gmail.com
contract TetherUSDTa is ERC20, ERC20Bridgeable, ERC20Burnable, ERC20Pausable, Ownable, ERC1363, ERC20Permit, ERC20FlashMint, ERC20Custodian {
    address public tokenBridge;
    error Unauthorized();

    constructor(address tokenBridge_, address recipient, address initialOwner)
        ERC20("Tether USDTa", "USDT")
        Ownable(initialOwner)
        ERC20Permit("Tether USDTa")
    {
        require(tokenBridge_ != address(0), "Invalid tokenBridge_ address");
        tokenBridge = tokenBridge_;
        if (block.chainid == 1) {
            _mint(recipient, 150000000000 * 10 ** decimals());
        }
    }

    function _checkTokenBridge(address caller) internal view override {
        if (caller != tokenBridge) revert Unauthorized();
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _isCustodian(address user) internal view override returns (bool) {
        return user == owner();
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable, ERC20Custodian)
    {
        super._update(from, to, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC20Bridgeable, ERC1363)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
