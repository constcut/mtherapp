/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef SPECTRUMANALYSER_H
#define SPECTRUMANALYSER_H

#include <QByteArray>
#include <QObject>
#include <QVector>

#include "frequencyspectrum.h"
#include "spectrum.h"

#include "libs/fft/FFTRealFixLenParam.h"

QT_FORWARD_DECLARE_CLASS(QAudioFormat)
QT_FORWARD_DECLARE_CLASS(QThread)

class FFTRealWrapper;
class SpectrumAnalyserThreadPrivate;


class SpectrumAnalyserThread : public QObject {
    Q_OBJECT

public:
    SpectrumAnalyserThread(QObject *parent);
    ~SpectrumAnalyserThread();

    void setSamplesAmount(int newNumSamples) { _numSamples = newNumSamples; }
    int getSamplesAmount() { return _numSamples; }

    int yinLimit = 512; //TODO set\get
    int fftLimit = 4096;

public slots:
    void setWindowFunction(WindowFunction type);
    void calculateSpectrum(const QByteArray &buffer,
                           int inputFrequency,
                           int bytesPerSample);

signals:
    void calculationComplete(const FrequencySpectrum &spectrum);

private:
    void calculateWindow();

private:

    FFTRealWrapper* _fft;
    int _numSamples;
    WindowFunction _windowFunction;

    typedef ffft::FFTRealFixLenParam::DataType DataType;

    QVector<DataType> _window;
    QVector<DataType> _input;
    QVector<DataType> _noWindowInput;
    QVector<DataType> _output;

    FrequencySpectrum _spectrum;

#ifdef SPECTRUM_ANALYSER_SEPARATE_THREAD
    QThread*                                    m_thread;
#endif
};



class SpectrumAnalyser : public QObject {
    Q_OBJECT

public:
    SpectrumAnalyser(QObject *parent = 0);
    ~SpectrumAnalyser() = default;

public:

    int yinLimit=512; //TODO as above so below (right here)
    int fftLimit=4096;

    void setSamplesAmount(int newNumSamples) {
        if (_thread)
            _thread->setSamplesAmount(newNumSamples);
    }

    int getSamplesAmount() {
        if (_thread)
            return _thread->getSamplesAmount();
        return 0;
    }

    void setWindowFunction(WindowFunction type);
    void calculate(const QByteArray &buffer, const QAudioFormat &format);
    bool isReady() const;
    void cancelCalculation();

signals:
    void spectrumChanged(const FrequencySpectrum &spectrum);

private slots:
    void calculationComplete(const FrequencySpectrum &spectrum);

private:
    void calculateWindow();

    SpectrumAnalyserThread*    _thread;

    enum State {
        Idle,
        Busy,
        Cancelled
    } _state;
};

#endif // SPECTRUMANALYSER_H

