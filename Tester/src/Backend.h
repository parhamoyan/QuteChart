// Backend.h
#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QVector>

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject *parent = nullptr);

    Q_INVOKABLE static void generateMonthlyDataToJson(); //const QString &filePath = "data.json"
    Q_INVOKABLE QVector<int> getMonthData(const QString &monthName);

signals:

public slots:
};

#endif // BACKEND_H
