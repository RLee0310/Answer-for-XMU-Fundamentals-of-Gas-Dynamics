# -*- coding: utf-8 -*-
"""
Moody 图与摩擦系数交互计算程序
模式：
1=已知 Re 和 ε/D 求摩擦系数 f
2=已知 f 和 ε/D 求 Re
3=已知 f 和 Re 求 ε/D
4=绘制指定 ε/D 的 Moody 图
"""

import numpy as np
from scipy.optimize import fsolve
import matplotlib.pyplot as plt
import matplotlib

matplotlib.rcParams['font.sans-serif'] = ['SimSun']  # 中文字体
matplotlib.rcParams['font.family'] = 'Times New Roman'  # 英文和数字字体
matplotlib.rcParams['axes.unicode_minus'] = False  # 解决负号显示问题

# -------------------- Colebrook 方程 --------------------
def colebrook(f, Re, eps_D):
    """Colebrook 方程"""
    return 1/np.sqrt(f) + 2.0*np.log10(eps_D/3.7 + 2.51/(Re*np.sqrt(f)))

def solve_f(Re, eps_D):
    """已知 Re 和相对粗糙度 eps/D，求摩擦系数 f"""
    f0 = 0.02
    f_sol, = fsolve(colebrook, f0, args=(Re, eps_D))
    return f_sol

def solve_Re(f, eps_D):
    """已知 f 和相对粗糙度 eps/D，求雷诺数 Re"""
    func = lambda Re: colebrook(f, Re, eps_D)
    Re_guess = 1e5
    Re_sol, = fsolve(func, Re_guess)
    return Re_sol

def solve_eps(f, Re):
    """已知 f 和 Re，求相对粗糙度 eps/D"""
    func = lambda eps_D: colebrook(f, Re, eps_D)
    eps_guess = 0.0001
    eps_sol, = fsolve(func, eps_guess)
    return eps_sol

# -------------------- Moody 图绘制 --------------------
def plot_moody(eps_list=[0.0001,0.0002,0.0005,0.001,0.002], Re_range=(4000,1e8)):
    Re = np.logspace(np.log10(Re_range[0]), np.log10(Re_range[1]), 500)
    plt.figure(figsize=(8,6))
    for eps_D in eps_list:
        f_vals = [solve_f(Rei, eps_D) for Rei in Re]
        plt.plot(Re, f_vals, label=f'ε/D={eps_D}')
    plt.xscale('log')
    plt.yscale('log')
    plt.xlabel("Re")
    plt.ylabel("f")
    plt.title("Moody Chart")
    plt.grid(True, which='both', linestyle='--', linewidth=0.5)
    plt.legend()
    plt.show()

# -------------------- 主程序 --------------------
if __name__ == "__main__":
    print("Moody 图与摩擦系数交互计算\n")
    print("模式选择：")
    print("1 = 已知 Re 和 ε/D 求 f")
    print("2 = 已知 f 和 ε/D 求 Re")
    print("3 = 已知 f 和 Re 求 ε/D")
    print("4 = 绘制 Moody 图")
    mode = input("请输入模式编号 (1/2/3/4)：").strip()

    if mode == "1":
        Re = float(input("请输入雷诺数 Re："))
        eps_D = float(input("请输入相对粗糙度 ε/D："))
        f = solve_f(Re, eps_D)
        print(f"\n已知 Re={Re:.2e}, ε/D={eps_D:.6f} → 摩擦系数 f={f:.6f}")

    elif mode == "2":
        f = float(input("请输入摩擦系数 f："))
        eps_D = float(input("请输入相对粗糙度 ε/D："))
        Re = solve_Re(f, eps_D)
        print(f"\n已知 f={f:.6f}, ε/D={eps_D:.6f} → 雷诺数 Re={Re:.2e}")

    elif mode == "3":
        f = float(input("请输入摩擦系数 f："))
        Re = float(input("请输入雷诺数 Re："))
        eps_D = solve_eps(f, Re)
        print(f"\n已知 f={f:.6f}, Re={Re:.2e} → 相对粗糙度 ε/D={eps_D:.6f}")

    elif mode == "4":
        eps_input = input("请输入相对粗糙度 ε/D（用逗号分隔，可留空使用默认值）：").strip()
        if eps_input:
            eps_list = [float(e.strip()) for e in eps_input.split(",")]
        else:
            eps_list = [0.0001,0.0002,0.0005,0.001,0.002]
        plot_moody(eps_list)
    else:
        print("模式输入错误，请输入 1、2、3 或 4。")
