#ifndef LIBRARYINFOWINDOW_H
#define LIBRARYINFOWINDOW_H

#include <QWidget>
#include <QLabel>

#include <QJsonObject>
#include <QJsonDocument>

#include <QTcpSocket>

class LibraryInfoWindow : public QWidget
{
    Q_OBJECT
public:
    explicit LibraryInfoWindow(QWidget *parent = 0);
    void setFund(float fund);

    void getLibraryInfo(QTcpSocket *tcpClient);
private:
    QLabel *fund;

signals:

public slots:
};

#endif // LIBRARYINFOWINDOW_H
