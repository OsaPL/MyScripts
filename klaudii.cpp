// klaudii.cpp : Defines the entry point for the console application.
//
// f(x)=(2*lamb*x)^(2*l+2) * exp^-2*lamb*x lagger(n,2*l+1,2*lamb*x) * lagger(m,2*l+1,2*lamb*x)

#include "stdafx.h"
#include <iostream>
#include <fstream>
#include <cmath>
#include <boost/math/special_functions/factorials.hpp>
#include <boost/math/special_functions/laguerre.hpp>
#include <boost/math/special_functions/bessel.hpp>

using namespace std;

void stala() {
	double E = 0;
	int l = 0;
	double v0 = 0;
	double a = 0;

	cout << "E = ";
	cin >> E;
	cout << "l = ";
	cin >> l;
	cout << "v0 = ";
	cin >> v0;
	cout << "a = ";
	cin >> a;

	double N = 0;
	double h = a *0.0001;
	int o = 1;
	N = 0;
	while (o*h < a) {
		if (o % 2 == 0)
			N += 4 * pow(o*h * boost::math::sph_bessel(l, (sqrt(2 * (E + v0)) *o*h)), 2);
		else
			N += 2 * pow(o*h * boost::math::sph_bessel(l, (sqrt(2 * (E + v0)) *o*h)), 2);;
		o++;
	}

	N += pow(a * boost::math::sph_bessel(l, (sqrt(2 * (E + v0)) *a)), 2);
	N *= h / 3;
	cout << "N = " << 1/sqrt(N) << endl;
	return;
}
void macierze()
{
	int lamb = 1;
	int a0 = 1;
	int l = 0;
	int v0 = 0;
	double E = -0.5;
	double e = 1;
	int a = 1;
	int n = 1;
	int m = 1;
	int b = 0;
	double tmp = 0;

	cout << "l = ";
	cin >> l;
	cout << "v0 = ";
	cin >> v0;
	cout << "a = ";
	cin >> a;
	cout << "b = ";
	cin >> b;
	cout << "n = ";
	cin >> n;
	cout << "m = ";
	cin >> m;

	double h = b * 0.0001;
	double dx = 0;
	int o = 0;
	double pm, pn, I1, I2, I3;
	I1 = 0;
	I2 = 0;
	I3 = 0;
	double** G = new double*[n];
	for (int i = 0; i < n; ++i)
		G[i] = new double[m];
	double** M = new double*[n];
	for (int i = 0; i < n; ++i)
		M[i] = new double[m];

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < m; j++) {
			pm = sqrt(boost::math::factorial<double>(j) / (lamb*a0*(j + l + 1)*boost::math::factorial<double>(j + 2 * l + 1)));
			pn = sqrt(boost::math::factorial<double>(i) / (lamb*a0*(i + l + 1)*boost::math::factorial<double>(i + 2 * l + 1)));
			o = 1;
			dx = boost::math::laguerre(i, 2 * l + 1, 0)*boost::math::laguerre(j, 2 * l + 1, 0)*pow(0, 2 * l + 2)*exp(-2 * lamb * 0);
			while (o*h < b) {
				if (o % 2 == 0)
					dx += 4 * boost::math::laguerre(i, 2 * l + 1, 2 * lamb*o*h)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*o*h)*pow(2 * lamb*o*h, 2 * l + 2)*exp(-2 * lamb*o*h);
				else
					dx += 2 * boost::math::laguerre(i, 2 * l + 1, 2 * lamb*o*h)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*o*h)*pow(2 * lamb*o*h, 2 * l + 2)*exp(-2 * lamb*o*h);
				o++;
			}

			dx += boost::math::laguerre(i, 2 * l + 1, 2 * lamb*b)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*b)*pow(2 * lamb*b, 2 * l + 2)*exp(-2 * lamb*b);
			dx *= h / 3;
			G[j][i] = dx*pn*pm;
			//teraz cos innegod
			if (j == i) {
				I1 = e*e;
			}
			else {
				I1 = 0;
			}
			I2 = E * dx*pn*pm;
			h = a * 0.0001;
			o = 1;
			dx = boost::math::laguerre(i, 2 * l + 1, 0)*boost::math::laguerre(j, 2 * l + 1, 0)*pow(0, 2 * l + 2)*exp(-2 * lamb * 0);
			while (o*h < a) {
				if (o % 2 == 0)
					dx += 4 * boost::math::laguerre(i, 2 * l + 1, 2 * lamb*o*h)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*o*h)*pow(2 * lamb*o*h, 2 * l + 2)*exp(-2 * lamb*o*h);
				else
					dx += 2 * boost::math::laguerre(i, 2 * l + 1, 2 * lamb*o*h)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*o*h)*pow(2 * lamb*o*h, 2 * l + 2)*exp(-2 * lamb*o*h);
				o++;
			}
			dx += boost::math::laguerre(i, 2 * l + 1, 2 * lamb*a)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*a)*pow(2 * lamb*a, 2 * l + 2)*exp(-2 * lamb*a);
			dx *= h / 3;
			I3 = v0*dx*pm*pn;
			M[j][i] = I1 + I2 + I3;
		}
	}

	std::ofstream plik;
	plik.open("Gje.txt");
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < m; j++) {
			plik << G[j][i] << "\t";
		}
		plik << endl;
	}
	plik.close();
	plik.open("Em.txt");
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < m; j++) {
			plik << M[j][i] << "\t";
		}
		plik << endl;
	}
	plik.close();

	cout << "kupa";
	return;
}
void potencjal()
{
	int lamb = 1;
	int l = 0;
	double E = -0.5;
	double e = 1;
	int n = 1;
	int m = 1;
	int b = 0;
	double tmp = 0;
	int a0 = 1;

	cout << "l = ";
	cin >> l;
	cout << "b = ";
	cin >> b;
	cout << "n = ";
	cin >> n;
	cout << "m = ";
	cin >> m;

	double h = b * 0.0001;
	double dx = 0;
	int o = 0;
	double pm, pn, I1, I2, I3, I4, I5;
	I1 = 0;
	I2 = 0;
	I3 = 0;
	I4 = 0;
	I5 = 0;
	double** D = new double*[n];
	for (int i = 0; i < n; ++i)
		D[i] = new double[m];
	double** H = new double*[n];
	for (int i = 0; i < n; ++i)
		H[i] = new double[m];

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < m; j++) {
			pm = sqrt(boost::math::factorial<double>(j) / (lamb*a0*(j + l + 1)*boost::math::factorial<double>(j + 2 * l + 1)));
			pn = sqrt(boost::math::factorial<double>(i) / (lamb*a0*(i + l + 1)*boost::math::factorial<double>(i + 2 * l + 1)));
			o = 1;
			dx = boost::math::laguerre(i, 2 * l + 1, 0)*boost::math::laguerre(j, 2 * l + 1, 0)*pow(0, 2 * l + 2)*exp(-2 * lamb * 0);
			while (o*h < b) {
				if (o % 2 == 0)
					dx += 4 * boost::math::laguerre(i, 2 * l + 1, 2 * lamb*o*h)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*o*h)*pow(2 * lamb*o*h, 2 * l + 2)*exp(-2 * lamb*o*h);
				else
					dx += 2 * boost::math::laguerre(i, 2 * l + 1, 2 * lamb*o*h)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*o*h)*pow(2 * lamb*o*h, 2 * l + 2)*exp(-2 * lamb*o*h);
				o++;
			}

			dx += boost::math::laguerre(i, 2 * l + 1, 2 * lamb*b)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*b)*pow(2 * lamb*b, 2 * l + 2)*exp(-2 * lamb*b);
			dx *= h / 3;
			D[j][i] = dx*pn*pm;
			//teraz cos innego
			//I1
			if (j == i) {
				I1 = e*e;
			}
			else {
				I1 = 0;
			}
			//I2
			I2 = E * dx*pn*pm;
			//I3
			h = b * 0.0001;
			o = 1;
			dx = boost::math::laguerre(i, 2 * l + 1, 0)*boost::math::laguerre(j, 2 * l + 1, 0)*pow(0, 2 * l)*exp(-2 * lamb * 0);
			while (o*h < b) {
				if (o % 2 == 0)
					dx += 4 * boost::math::laguerre(i, 2 * l + 1, 2 * lamb*o*h)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*o*h)*pow(2 * lamb*o*h, 2 * l)*exp(-2 * lamb*o*h);
				else
					dx += 2 * boost::math::laguerre(i, 2 * l + 1, 2 * lamb*o*h)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*o*h)*pow(2 * lamb*o*h, 2 * l)*exp(-2 * lamb*o*h);
				o++;
			}
			dx += boost::math::laguerre(i, 2 * l + 1, 2 * lamb*b)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*b)*pow(2 * lamb*b, 2 * l)*exp(-2 * lamb*b);
			dx *= h / 3;
			I3 = 2 * dx*pm*pn;
			//I4
			h = b * 0.0001;
			o = 1;
			dx = boost::math::laguerre(i, 2 * l + 1, 0)*boost::math::laguerre(j, 2 * l + 1, 0)*pow(0, 2 * l + 1)*exp(-2 * lamb * 0);
			while (o*h < b) {
				if (o % 2 == 0)
					dx += 4 * boost::math::laguerre(i, 2 * l + 1, 2 * lamb*o*h)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*o*h)*pow(2 * lamb*o*h, 2 * l + 1)*exp(-2 * lamb*o*h);
				else
					dx += 2 * boost::math::laguerre(i, 2 * l + 1, 2 * lamb*o*h)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*o*h)*pow(2 * lamb*o*h, 2 * l + 1)*exp(-2 * lamb*o*h);
				o++;
			}
			dx += boost::math::laguerre(i, 2 * l + 1, 2 * lamb*b)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*b)*pow(2 * lamb*b, 2 * l + 1)*exp(-2 * lamb*b);
			dx *= h / 3;
			I4 = -3 * dx*pm*pn;
			//I5
			h = b * 0.0001;
			o = 1;
			dx = boost::math::laguerre(i, 2 * l + 1, 0)*boost::math::laguerre(j, 2 * l + 1, 0)*pow(0, 2 * l + 3)*exp(-2 * lamb * 0);
			while (o*h < b) {
				if (o % 2 == 0)
					dx += 4 * boost::math::laguerre(i, 2 * l + 1, 2 * lamb*o*h)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*o*h)*pow(2 * lamb*o*h, 2 * l + 3)*exp(-2 * lamb*o*h);
				else
					dx += 2 * boost::math::laguerre(i, 2 * l + 1, 2 * lamb*o*h)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*o*h)*pow(2 * lamb*o*h, 2 * l + 3)*exp(-2 * lamb*o*h);
				o++;
			}
			dx += boost::math::laguerre(i, 2 * l + 1, 2 * lamb*b)*boost::math::laguerre(j, 2 * l + 1, 2 * lamb*b)*pow(2 * lamb*b, 2 * l + 3)*exp(-2 * lamb*b);
			dx *= h / 3;
			I5 = dx*pm*pn;
			H[j][i] = I1 + I2 + I3 + I4 + I5;
		}
	}

	std::ofstream plik;
	plik.open("De.txt");
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < m; j++) {
			plik << D[j][i] << "\t";
		}
		plik << endl;
	}
	plik.close();
	plik.open("Ha.txt");
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < m; j++) {
			plik << H[j][i] << "\t";
		}
		plik << endl;
	}
	plik.close();

	cout << "kupa";
	return;
}
void main() {
	int temp;
	cout << "Wybierz funkcje:" << endl;
	cout << "Macierze:1" << endl;
	cout << "Stala:2" << endl;
	cout << "Potencjal:3" << endl;
	cin >> temp;
	switch (temp) {
	case 1:macierze(); break;
	case 2:stala(); break;
	case 3:potencjal(); break;
	default:break;
	}
	system("pause");
	return;
}
