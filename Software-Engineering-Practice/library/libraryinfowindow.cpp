#include "libraryinfowindow.h"

LibraryInfoWindow::LibraryInfoWindow(QWidget *parent) : QWidget(parent)
{
    this->resize(600, 400);
    this->setWindowTitle("图书馆信息");

    fund = new QLabel(this);
    fund->move(20, 20);
}

void LibraryInfoWindow::setFund(float fund)
{
    QString temp = "图书馆经费余额：";
    temp = temp + QString::number(fund, 'f', 2) + "元";
    this->fund->setText(temp);
}

void LibraryInfoWindow::getLibraryInfo(QTcpSocket *tcpClient)
{
    QJsonObject getLibraryInfoPackage;

    getLibraryInfoPackage.insert("type", "get library information");


    QByteArray byte_array = QJsonDocument(getLibraryInfoPackage).toJson();
    tcpClient->write(byte_array);
    if(tcpClient->waitForReadyRead(1000))//阻塞式连接
    {
        QByteArray result = tcpClient->readAll();
        if(!result.isEmpty())
        {
            QJsonObject resultInfo = QJsonDocument::fromJson(result).object();

            this->setFund(resultInfo.value("fund").toDouble());

        }
    }
}
