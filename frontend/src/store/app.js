// Utilities
import { defineStore } from 'pinia'
import $ from "jquery";
import Swal from "sweetalert2";

export const useAppStore = defineStore('app', {
  persist: {
    pick: ['sessionId']
  },
  state: () => ({
    //
    cachedImage: "",
    sessionId: "",
    preload: false,
    apiserver: `${import.meta.env.VITE_API_SERVER}/`,
    pdfdata: {
      element: '',
      data: null
    },
    alert: Swal.mixin({
      toast: true,
      position: "top-end",
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true,
      didOpen: (toast) => {
        toast.onmouseenter = Swal.stopTimer;
        toast.onmouseleave = Swal.resumeTimer;
      },
      customClass: {
        container: "swal-custom-zindex", // Class kustom untuk elemen swal
      },
    }),
  }),
  actions: {
    togglePreload() {
      setTimeout(() => {
        this.preload = false
      }, 1000);
    },
    ajax(data, url, methode, isFile = false) {
      return new Promise((resolve, reject) => {
        $.ajax({
          beforeSend: () => {
            this.preload = true
          },
          type: methode,
          url: this.apiserver + url,
          data: data,
          dataType: isFile ? undefined : "JSON", // Jangan pakai JSON jika upload file
          processData: !(data instanceof FormData), // Jangan proses FormData
          contentType: !(data instanceof FormData) ? "application/x-www-form-urlencoded; charset=UTF-8" : false, // Jangan set contentType jika FormData
          success: function (response) {
            resolve(response);
            useAppStore().preload = false
          },
          error: (error) => {
            reject(error.responseJSON);
            useAppStore().preload = false
          },
        });
      });
    },
    dataUrlToFile(dataUrl, fileName) {
      let arr = dataUrl.split(","), // Pisahkan header dan data
        mime = arr[0].match(/:(.*?);/)[1], // Ambil MIME type
        bstr = atob(arr[1]), // Decode base64
        n = bstr.length,
        u8arr = new Uint8Array(n);

      while (n--) {
        u8arr[n] = bstr.charCodeAt(n);
      }

      return new File([u8arr], fileName, { type: mime });
    },
    fileToDataURL(file) {
      return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => resolve(reader.result); // Hasil dalam bentuk Data URL
        reader.onerror = (error) => reject(error);
      });
    },
    validateMeasurement(name, value, args = []) {
      const validator = {
        matchString: (a) => value === a, // Bandingkan dengan string tertentu
        matchNumber: (a) => Number(value) === Number(a), // Bandingkan dengan angka tertentu
        numberRange: (min, max) => Number(value) >= min && Number(value) <= max, // Cek dalam rentang angka
        largerThan: (a) => Number(value) > Number(a), // Lebih besar dari angka tertentu
        lessThan: (a) => Number(value) < Number(a), // Lebih kecil dari angka tertentu
        minLength: (len) => String(value).length >= len, // Minimal panjang string
        maxLength: (len) => String(value).length <= len, // Maksimal panjang string
        notEmpty: () => String(value).trim().length > 0, // Tidak boleh kosong
        includes: (...values) => values.includes(value), // Cek apakah termasuk dalam array nilai tertentu
      };
      return validator[name] ? validator[name](...args) : false;
    }

  }
})
