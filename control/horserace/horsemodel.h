#ifndef HORSEMODEL_H
#define HORSEMODEL_H

#include <QObject>

class HorseModel : public QObject {
    Q_OBJECT
    Q_PROPERTY( double stars READ stars NOTIFY starsChanged )
    Q_PROPERTY( int speed READ speed NOTIFY speedChanged )
    Q_PROPERTY( QString name READ name WRITE setName NOTIFY nameChanged )
    Q_PROPERTY( QString image READ image NOTIFY imageChanged )

public:
    HorseModel();

    double stars() const;

    int speed() const;

    QString name() const;
    void setName( const QString& name );

    QString image();

signals:
    void starsChanged();
    void speedChanged();
    void nameChanged();
    void imageChanged();

private:
    void setImage( QString image );
    void setStars();
    void setSpeed( double stars );
    double _stars;
    int _speed;
    QString _name;
    QString _image;
};

#endif // HORSEMODEL_H
