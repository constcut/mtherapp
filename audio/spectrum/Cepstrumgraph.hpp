#ifndef CepstrumgraphQML_H
#define CepstrumgraphQML_H


#include <QQuickPaintedItem>
#include <QPainter>
#include <QByteArray>

#include <unordered_set>

#include "audio/features/WindowFunction.hpp"


namespace aural_sight {



    class CepstrumgraphQML : public QQuickPaintedItem
    {
            Q_OBJECT
    public:
        CepstrumgraphQML([[maybe_unused]] QQuickItem* parent = nullptr)
        : _input(4096, 0.f),
          _windowBufer(4096, 0.f)
        {  }

        ~CepstrumgraphQML() = default;

        void paint(QPainter* painter);

        Q_INVOKABLE bool loadByteArray(QByteArray analyseData);
        Q_INVOKABLE void loadFloatSamples(QByteArray samples);

        Q_INVOKABLE void setCursor(double pos) {
            _cursorPos = pos;
            update();
        }

        Q_INVOKABLE void saveImage(QString filename) { _mainImage.save(filename); }

        Q_INVOKABLE void setWindowFunction(int idx) {
            _window = static_cast<WindowFunction>(idx);
            updateWindowFunction();
        }

        Q_INVOKABLE void changeSampleRate(int newSampleRate);
        Q_INVOKABLE void changeWindowSize(int newWindowSize);

    private:

        std::vector<float> _input;
        std::vector<float> _windowBufer;

        double _cursorPos = -1.0;

        size_t _sampleRate = 44100.0;
        size_t _windowSize = 4096;

        WindowFunction _window = WindowFunction::NoWindow;

        void prepareBackground(QPainter &painter) const;

        void paintBufer(QPainter& painter, const std::vector<float>& bufer,
                           size_t size, QString color, float heightPos, float scaleCoef);

        void paintImage(QPainter& painter);

        void updateWindowFunction();

        QImage _mainImage;
        bool _imagePainted = false;

    };

}
#endif // CepstrumgraphQML_H
