function numberOfDays(month) {
    const monthDays = {
        "January": 31,
        "February": 28, // or 29 in leap years
        "March": 31,
        "April": 30,
        "May": 31,
        "June": 30,
        "July": 31,
        "August": 31,
        "September": 30,
        "October": 31,
        "November": 30,
        "December": 31
    };

    return monthDays[month];
}

function getMonthAbbreviation(monthIndex) {
    const monthsAbbreviations = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return monthsAbbreviations[monthIndex];
}
