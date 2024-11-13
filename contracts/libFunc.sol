// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
library libFunc {
   
    uint constant SECONDS_PER_DAY = 24 * 60 * 60;
    uint constant DAYS_IN_YEAR = 365;
    uint constant DAYS_IN_LEAP_YEAR = 366;

    function intToString(uint val) internal pure returns (string memory) {
        if (val == 0) {
            return "0";
        }
        uint temp = val;
        uint digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (val != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint(val % 10)));
            val /= 10;
        }
        return string(buffer);
    }

    function stringToInt(string memory val) internal pure returns (uint) {
        bytes memory b = bytes(val);
        uint number;
        for (uint i = 0; i < b.length; i++) {
            require(b[i] >= 0x30 && b[i] <= 0x39, "Invalid character");
            number = number * 10 + (uint8(b[i]) - 48);
        }
        return number;
    }

    // تبدیل timestamp به فرمت YYYY-MM-DD
    function dateToString(uint timestamp) internal pure returns (string memory) {
        uint year = 1970;
        uint totalDays = timestamp / SECONDS_PER_DAY;
        
        // محاسبه سال
        while (totalDays >= DAYS_IN_YEAR) {
            if (isLeapYear(year)) {
                if (totalDays >= DAYS_IN_LEAP_YEAR) {
                    totalDays -= DAYS_IN_LEAP_YEAR;
                } else {
                    break;
                }
            } else {
                totalDays -= DAYS_IN_YEAR;
            }
            year++;
        }

        // محاسبه ماه و روز
        uint[12] memory monthDays = [uint(31), isLeapYear(year) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        uint month;
        for (month = 0; month < 12; month++) {
            if (totalDays < monthDays[month]) {
                break;
            }
            totalDays -= monthDays[month];
        }

        uint day = totalDays + 1; // از 1 تا 31

        // تبدیل به رشته و بازگرداندن
        string memory yearStr = intToString(year);
        string memory monthStr = month + 1 < 10 ? string(abi.encodePacked("0", intToString(month + 1))) : intToString(month + 1);
        string memory dayStr = day < 10 ? string(abi.encodePacked("0", intToString(day))) : intToString(day);

        return string(abi.encodePacked(yearStr, "-", monthStr, "-", dayStr));
    }

    // تابع بررسی سال کبیسه
    function isLeapYear(uint year) internal pure returns (bool) {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    }
}