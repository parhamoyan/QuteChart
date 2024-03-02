// Backend.cpp
#include "Backend.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>
#include <QDebug>

Backend::Backend(QObject *parent) : QObject(parent)
{

}

void Backend::generateMonthlyDataToJson()
{
    // Create a JSON object
    QJsonObject jsonObject;

    // Seed the random number generator
    std::srand(QDateTime::currentMSecsSinceEpoch() / 1000);

    // Generate data for each month
    QStringList monthNames = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
    QMap<QString, int> monthDays = {
        {"January", 31},
        {"February", 28}, // or 29 in leap years
        {"March", 31},
        {"April", 30},
        {"May", 31},
        {"June", 30},
        {"July", 31},
        {"August", 31},
        {"September", 30},
        {"October", 31},
        {"November", 30},
        {"December", 31}
    };
    // Generate random data for each month
    for (int i = 0; i < monthNames.size(); ++i) {
        QString monthName = monthNames.at(i);
        int numDays = monthDays.value(monthName, -1); // Get the number of days for the month

        if (numDays == -1) {
            qDebug() << "Invalid month name:" << monthName;
            continue;
        }

        QJsonArray monthData;

        // Generate random numbers for each day of the month
        for (int j = 0; j < numDays; ++j) {
            int randomNumber = std::rand() % (30000 - 10 + 1) + 10 + 2000;
            monthData.append(randomNumber);
        }

        // Add the month's data to the JSON object
        jsonObject.insert(monthName, monthData);
    }

    // Convert JSON object to JSON document
    QJsonDocument jsonDoc(jsonObject);

    // Write JSON document to a file
    QFile file("data.json");
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file for writing.";
    }
    file.write(jsonDoc.toJson());
    file.close();

    qDebug() << "JSON file created successfully.";
}


QVector<int> Backend::getMonthData(const QString &monthName)
{
    QVector<int> monthData;

    // Read JSON file
    QFile file("data.json");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file for reading:" << file.errorString();
        return monthData;
    }

    // Parse JSON document
    QByteArray jsonData = file.readAll();
    QJsonDocument jsonDoc = QJsonDocument::fromJson(jsonData);
    file.close();

    // Check if JSON document is an object
    if (!jsonDoc.isObject()) {
        qDebug() << "Invalid JSON data: not an object.";
        return monthData;
    }

    // Get JSON object
    QJsonObject jsonObject = jsonDoc.object();

    // Check if the month exists in the JSON object
    if (!jsonObject.contains(monthName)) {
        qDebug() << "Month" << monthName << "not found in JSON data.";
        return monthData;
    }

    // Get JSON array for the specified month
    QJsonArray monthArray = jsonObject.value(monthName).toArray();

    // Convert JSON array to QVector<int>
    for (const QJsonValue &value : monthArray) {
        if (value.isDouble()) {
            monthData.append(value.toInt());
        } else {
            qDebug() << "Invalid data format in JSON array for month" << monthName << ":" << value;
        }
    }

    while (monthData.size() < 31) {
        monthData.append(-1);
    }

    return monthData;
}
