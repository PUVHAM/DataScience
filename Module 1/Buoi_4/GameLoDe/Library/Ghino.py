from .XuLyFile import *
from .MyPath import *
from .XuLyTaiKhoan import *
from .LoDeHoc import *
from datetime import datetime

def ghi_no(username, so_tien_vay):
    try:
        thoi_gian_ghi_no = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        thong_tin_no = f"{thoi_gian_ghi_no},{username},{so_tien_vay}\n"
        
        ghi_file([thong_tin_no], PATH_DATA_NO, "a")
        print("Thông tin về việc ghi nợ đã được lưu.")
    except Exception as e:
        print(f"Có lỗi xảy ra khi ghi nợ: {e}")

def tinh_tong_tien_thua():
    try:
        du_lieu_choi_lo = doc_file(PATH_DATA_CHOI_LO, "r")
        tong_tien_thua = sum(int(choi_lo[-1]) for choi_lo in du_lieu_choi_lo)
        return tong_tien_thua
    except Exception as e:
        print(f"Có lỗi xảy ra khi tính tổng tiền thua: {e}")
        return 0

def thanh_toan_no(username, so_tien_thanh_toan):
    try:
        if int(lay_thong_tin_tai_khoan(username)[2]) > 0:
            du_lieu_no = doc_file(PATH_DATA_NO, "r")
    
            for i, record in enumerate(du_lieu_no):
                if record[0] == username:
                    so_tien_no_hien_tai = int(record[1])
                    so_tien_thanh_toan += so_tien_thanh_toan * 0.02  # Tính lãi suất 2%
                    du_lieu_no[i][1] = str(max(0, so_tien_no_hien_tai - so_tien_thanh_toan))  # Giảm số tiền nợ và không để số tiền nợ âm
    
            ghi_file([','.join(record) + '\n' for record in du_lieu_no], PATH_DATA_NO, "w")
    
            cap_nhat_tien_choi_lo(username, so_tien_thanh_toan)
    
            print(f"Đã thanh toán nợ thành công cho tài khoản {username}.")
        else:
            print(f"Tài khoản trống không đủ tiền.")
    except Exception as e:
        print(f"Có lỗi xảy ra khi thanh toán nợ: {e}")
