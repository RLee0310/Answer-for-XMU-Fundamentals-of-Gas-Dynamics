# -*- coding: utf-8 -*-
"""
马赫数 M 与比值互算程序（1=A/A*, 2=T/Tt, 3=p/pt, 4=rho/rhot）

"""

import numpy as np
from scipy.optimize import fsolve

# --------------------------- 函数定义 ---------------------------
gamma_default = 1.4

# 使用 Unicode 显示希腊字母和下标
ratio_dict = {
    '1': 'A/A*',
    '2': 'T/Tₜ',
    '3': 'p/pₜ',
    '4': 'ρ/ρₜ'
}

def mach_to_ratios(M, gamma=gamma_default):
    """通过马赫数计算各比值"""
    A_Astar = 1/M * ((1 + (gamma-1)/2*M**2)/((gamma+1)/2))**((gamma+1)/(2*(gamma-1)))
    T_Tt = 1 / (1 + (gamma-1)/2*M**2)
    p_pt = T_Tt**(gamma/(gamma-1))
    rho_rhot = T_Tt**(1/(gamma-1))
    return A_Astar, T_Tt, p_pt, rho_rhot

def ratio_to_mach(value, ratio_type, gamma=gamma_default, supersonic=True):
    """通过比值反算马赫数"""
    def func(M):
        A_Astar, T_Tt, p_pt, rho_rhot = mach_to_ratios(M, gamma)
        if ratio_type == '1':
            return A_Astar - value
        elif ratio_type == '2':
            return T_Tt - value
        elif ratio_type == '3':
            return p_pt - value
        elif ratio_type == '4':
            return rho_rhot - value
        else:
            raise ValueError("ratio_type 必须是 1(A/A*),2(T/Tt),3(p/pt),4(rho/rhot)")
    
    if ratio_type == '1':
        # 面积比需要区分亚音速/超音速
        M0 = 0.5 if not supersonic else 2.0
    else:
        M0 = 0.5 if value < 1 else 2.0

    M_solution, = fsolve(func, M0)
    return M_solution

# --------------------------- 主程序 ---------------------------
if __name__ == "__main__":
    print("马赫数 M 与比值互算程序（1=A/A*, 2=T/Tₜ, 3=p/pₜ, 4=ρ/ρₜ）\n")
    print("模式选择：")
    print("1 = 已知 M 求比值")
    print("2 = 已知比值求 M")
    mode = input("请输入模式编号 (1/2)：").strip()

    gamma = input("请输入比热比 γ（默认 1.4）：").strip()
    gamma = float(gamma) if gamma else gamma_default

    if mode == "1":
        M = float(input("请输入马赫数 M："))
        A_Astar, T_Tt, p_pt, rho_rhot = mach_to_ratios(M, gamma)
        print(f"\n马赫数 M = {M}")
        print(f"{ratio_dict['1']} = {A_Astar:.6f}")
        print(f"{ratio_dict['2']} = {T_Tt:.6f}")
        print(f"{ratio_dict['3']} = {p_pt:.6f}")
        print(f"{ratio_dict['4']} = {rho_rhot:.6f}")

    elif mode == "2":
        print("可用比值类型：1=A/A*, 2=T/Tₜ, 3=p/pₜ, 4=ρ/ρₜ")
        ratio_type = input("请输入比值类型编号：").strip()
        ratio_value = float(input(f"请输入 {ratio_dict[ratio_type]} 的值："))
        supersonic = True
        if ratio_type == '1':
            branch = input("面积比 A/A* 求解分支：1=亚音速，2=超音速：").strip()
            supersonic = (branch == "2")

        M = ratio_to_mach(ratio_value, ratio_type, gamma, supersonic)
        A_Astar, T_Tt, p_pt, rho_rhot = mach_to_ratios(M, gamma)
        print(f"\n{ratio_dict[ratio_type]} = {ratio_value} 对应马赫数 M = {M:.6f}")
        print(f"{ratio_dict['1']} = {A_Astar:.6f}")
        print(f"{ratio_dict['2']} = {T_Tt:.6f}")
        print(f"{ratio_dict['3']} = {p_pt:.6f}")
        print(f"{ratio_dict['4']} = {rho_rhot:.6f}")

    else:
        print("模式输入错误，请输入 1 或 2。")